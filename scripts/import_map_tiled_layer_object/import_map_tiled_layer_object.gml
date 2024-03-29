function import_map_tiled_layer_object(x, y, z, json, columns, alpha, tiled_cache) {
    var layer_flag = 0;
    
    var map = Stuff.map.active_map;
    
    var layer_objects = json.objects;
    var layer_name = json.name;
    var layer_alpha = json.opacity;
    var layer_visible = json.visible;
    var layer_data_x = json.x;
    var layer_data_y = json.y;
    var layer_base_z = z;
    var layer_properties = json[$ "properties"];
    if (layer_properties != undefined) {
        for (var i = 0; i < array_length(layer_properties); i++) {
            var property_data = layer_properties[i];
            var property_name = property_data.name;
            if (string_copy(property_name, 1, 4) == "Tag_") {
                var imported = string_lettersdigits(string_lower(string(property_data.value)));
                for (var j = 0; j < array_length(Game.vars.flags); j++) {
                    if (string_lettersdigits(string_lower(Game.vars.flags[j])) == imported) {
                        layer_flag |= (1 << j);
                        break;
                    }
                }
            }
        }
    }
    
    var tmx_cache = tiled_cache[$ "&tmx-ids"];
    
    for (var i = 0; i < array_length(layer_objects); i++) {
        var object = layer_objects[i];
        var obj_id = object.id;
        var obj_x = object.x;
        var obj_y = object.y;
        
        if (!is_clamped((x + obj_x) / TILE_WIDTH, 0, map.xx - 1)) continue;
        if (!is_clamped((y + obj_y) / TILE_HEIGHT, 0, map.yy - 1)) continue;
        if (!is_clamped(z, 0, map.zz - 1)) continue;
        
        var obj_gid_local = object[$ "gid"];
        var obj_name = object[$ "name"];
        var obj_template = object[$ "template"];
        var obj_properties = object[$ "properties"];
        var obj_type = object[$ "type"];
        var obj_visible = object[$ "visible"];
        var obj_width = object[$ "width"];
        var obj_height = object[$ "height"];
        
        // if the layer has a tag assigned to it, instead of creating an
        // instance of a mesh or whatever, convert its area to a tag
        if (layer_flag) {
            var x1 = obj_x div TILE_WIDTH;
            var y1 = obj_y div TILE_HEIGHT;
            var x2 = x1 + (obj_width div TILE_WIDTH);
            var y2 = y1 + (obj_height div TILE_HEIGHT);
            for (var j = x1; j < x2; j++) {
                for (var k = y1; k < y2; k++) {
                    map.SetFlag(j, k, z, layer_flag);
                }
            }
            continue;
        }
        
        var data_template = undefined;
        var data_template_root = undefined;
        if (obj_template != undefined) {
            data_template_root = import_map_tiled_get_cached_object(tiled_cache, obj_template);
            data_template = data_template_root.object;
        }
        
        var data_gid = obj_gid_local;
        var data_name = obj_name;
        var data_type = obj_type;
        var data_visible = obj_visible;
        var data_width = obj_width;
        var data_height = obj_height;
        
        if (!data_template) {
            if (obj_gid_local == undefined) continue;
            if (obj_name == undefined) continue;
            if (obj_type == undefined) continue;
            if (obj_visible == undefined) continue;
            if (obj_width == undefined) continue;
            if (obj_height == undefined) continue;
        } else {
            data_name = (obj_name == undefined) ? data_template.name : obj_name;
            data_type = (obj_type == undefined) ? data_template.type : obj_type;
            data_visible = (obj_visible == undefined) ? data_template.visible : obj_visible;
            data_width = (obj_width == undefined) ? data_template.width : obj_width;
            data_height = (obj_height == undefined) ? data_template.height : obj_height;
            
            // because this gid system makes everything extremely fun and
            // enjoyable to work with
            if (obj_gid_local == undefined) {
                var ts_object = data_template_root.tileset;
                var ts_base_list = tiled_cache[$ "%tilesets"];
                for (var j = 0; j < array_length(ts_base_list); j++) {
                    var ts_data = ts_base_list[j];
                    if (string_count(ts_data.source, ts_object.source) > 0) {
                        data_gid = ts_data.firstgid + data_template.gid - 1 ;
                        break;
                    }
                }
            } else {
                data_gid = obj_gid_local;
            }
        }
        
        // merging the property maps does not sound like my idea of a fun time,
        // but not doing it would be even worse
        var data_properties = { };
        
        // the properties given to the instantiated object go first
        if (obj_properties != undefined) {
            for (var j = 0; j < array_length(obj_properties); j++) {
                var given = obj_properties[j];
                data_properties[$ given.name] = { name: given.name, value: given.value, };
            }
        }
        // the properties of the template go last - if any can be found
        if (data_template && data_template[$ "properties"] != undefined) {
            var template_properties = data_template.properties;
            if (template_properties != undefined) {
                for (var j = 0; j < array_length(template_properties); j++) {
                    var given = template_properties[j];
                    if (!data_properties[$ given.name]) {
                        data_properties[$ given.name] = { name: given.name, value: given.value };
                    }
                }
            }
        }
        
        // extract the information about the tile the object uses
        var gid_cache = tiled_cache[$ "&gid"];
        var gid_to_image_name = gid_cache[$ data_gid];
        
        if (gid_to_image_name == undefined) {
            var ts_json_data = undefined;
            var ts_base_list = tiled_cache[$ "%tilesets"];
            for (var j = array_length(ts_base_list) - 1; j >= 0; j--) {
                var ts_data = ts_base_list[j];
                if (ts_data.firstgid <= data_gid) {
                    ts_json_data = ts_base_list[j];
                    break;
                }
            }
            
            // i do NOT want to go through this every time so i'm going to cache
            // the result when i can since the gids are [waves hands] global
            var tileset_data = import_map_tiled_get_cached_tileset(tiled_cache, ts_json_data.source);
            var tileset_tile_data = tileset_data.tiles;
            var tile_id = data_gid - ts_json_data.firstgid;
            for (var j = 0; j < array_length(tileset_tile_data); j++) {
                var tileset_tile_data_object = tileset_tile_data[j];
                if (tileset_tile_data_object.id == tile_id) {
                    gid_to_image_name = filename_name(filename_change_ext(tileset_tile_data_object.image, ""));
                    gid_cache[$ data_gid] = gid_to_image_name;
                }
            }
            // pretty sure this isn't used for anything?
            //var tileset_tile_individual = tileset_tile_data[data_gid - ts_json_data.firstgid];
        }
        
        var instance = noone;
        var update = false;
        
        switch (string_lower(data_type)) {
            case "pawn":
            #region load pawn
                var pr_static = data_properties[$ "Static?"];
                
                if (pr_static == undefined) break;
                
                pr_static = pr_static.value;
                
                var thing = internal_name_get(gid_to_image_name);
                
                if (tmx_cache[$ obj_id]) {
                    instance = tmx_cache[$ obj_id];
                    map.Remove(instance);
                    if (thing) {
                        instance.overworld_sprite = thing.GUID;
                        // position for NPCs is at -1 because of where the
                        // origin for sprites is in Tiled
                        map.Add(instance, (x + obj_x) div TILE_WIDTH, (y + obj_y) div TILE_HEIGHT - 1, z, false, false);
                    } else {
                        //thing.Destroy();
                        updated = true;
                    }
                } else if (thing) {
                    instance = new EntityPawn("Pawn");
                    instance.tmx_id = obj_id;
                    instance.overworld_sprite = thing.GUID;
                    // position for NPCs is at -1 because of where the origin
                    // for sprites is in Tiled
                    map.Add(instance, (x + obj_x) div TILE_WIDTH, (y + obj_y) div TILE_HEIGHT - 1, z);
                } else {
                    wtf("GID not found: " + gid_to_image_name);
                }
                break;
            #endregion
            case "mesh":
            #region load mesh
                var pr_static = data_properties[$ "Static?"];
                var pr_offset_x = data_properties.OffsetX;
                var pr_offset_y = data_properties.OffsetY;
                
                if (pr_static == undefined) break;
                pr_offset_x = pr_offset_x ? pr_offset_x.value : 0;
                pr_offset_y = pr_offset_y ? pr_offset_y.value : 0;
                
                pr_static = pr_static.value;
                
                var pr_mesh_data = internal_name_get(gid_to_image_name);
                if (pr_mesh_data) {
                    if (tmx_cache[$ obj_id]) {
                        instance = tmx_cache[$ obj_id];
                        update = true;
                        // The entity only needs to be relocated; it doesn't
                        // need to be removed from the lists, or re-added later,
                        // because that would take a lot of time
                        map.Remove(instance);
                        map.Add(instance, (x + obj_x) div TILE_WIDTH, (y + obj_y) div TILE_HEIGHT, z, false, false);
                    } else {
                        instance = new EntityMesh("Mesh", pr_mesh_data);
                        instance.tmx_id = obj_id;
                        map.Add(instance, (x + obj_x) div TILE_WIDTH, (y + obj_y) div TILE_HEIGHT, z);
                    }
                    instance.off_xx = pr_offset_x / TILE_WIDTH;
                    instance.off_yy = pr_offset_y / TILE_HEIGHT;
                    instance.is_static = pr_static;
                } else {
                    wtf("Log an error somewhere - no existing mesh \"" + string(gid_to_image_name) + "\"" + " for " + string(data_name));
                }
                break;
            #endregion
            case "effect":
            default:
                not_yet_implemented();
                break;
        }
        
        if (instance) {
            instance.name = data_name;
            
            #region Default conversations
            var pr_cutscene_entrypoint = data_properties[$ "CutsceneEntrypoint"];
            var pr_autorun_entrypoint = data_properties[$ "AutorunEntrypoint"];
            pr_cutscene_entrypoint = pr_cutscene_entrypoint ? event_get_node_global(pr_cutscene_entrypoint.value) : undefined;
            pr_autorun_entrypoint = pr_autorun_entrypoint ? event_get_node_global(pr_autorun_entrypoint.value) : undefined;
            // arrays don't have a truth value apparently
            if (pr_cutscene_entrypoint) {
                var page = undefined;
                for (var j = 0; j < array_length(instance.object_events); j++) {
                    if (instance.object_events[j].trigger == 0x01) {
                        page = instance.object_events[j];
                        break;
                    }
                }
                if (!page) {
                    page = new InstantiatedEvent("");
                    array_push(instance.object_events, page);
                }
                
                page.name = "Conversation:" + pr_cutscene_entrypoint.name;
                page.trigger = 0x01;   // action button
                page.event_entrypoint = pr_cutscene_entrypoint.GUID;
            }
            if (pr_autorun_entrypoint) {
                var page = undefined;
                for (var j = 0; j < array_length(instance.object_events); j++) {
                    if (instance.object_events[j].trigger == 0x08) {
                        page = instance.object_events[j];
                        break;
                    }
                }
                if (!page) {
                    page = new InstantiatedEvent("");
                    array_push(instance.object_events, page);
                }
                page.name = "Autorun:" + pr_autorun_entrypoint.name;
                page.trigger = 0x08;   // autorun
                page.event_entrypoint = pr_autorun_entrypoint.GUID;
            }
            #endregion
            
            #region generic properties
            var property_list = variable_struct_get_names(data_properties);
            for (var j = 0; j < array_length(property_list); j++) {
                var property = data_properties[$ property_list[j]];
                var property_name = property.name;
                
                var property_value = undefined;
                var property_value_guid = NULL;
                var property_type = DataTypes.INT;
                var base_property_name = "";
                
                switch (string_char_at(property_name, 1)) {
                    case "@":
                        var data = internal_name_get(property.value);
                        if (data) {
                            base_property_name = string_replace(property_name, "@", "");
                            property_value = data.GUID;
                            property_value_guid = guid_get(data.parent).GUID;
                            property_type = DataTypes.DATA;
                        } else {
                            wtf("internal name not found - " + property.value);
                            continue;
                        }
                        break;
                    case "$":
                        base_property_name = string_replace(property_name, "$", "");
                        property_value = property.value;
                        property_type = DataTypes.STRING;
                        break;
                    case "#":
                        base_property_name = string_replace(property_name, "#", "");
                        property_value = property.value;
                        switch (property.type) {
                            case "string":      property_type = DataTypes.STRING;       break;
                            case "bool":        property_type = DataTypes.BOOL;         break;
                            case "float":       property_type = DataTypes.FLOAT;        break;
                            case "int":         property_type = DataTypes.INT;          break;
                            case "color":
                                // tiled stores color in ARGB and we need it to
                                // be in ABGR
                                property_type = DataTypes.COLOR;
                                var a = property_value >> 24;
                                property_value &= 0x00ffffff;
                                var b = colour_get_red(property_value);
                                var g = colour_get_green(property_value);
                                var r = colour_get_blue(property_value);
                                property_value = make_colour_rgb(r, g, b) | a;
                                break;
                        }
                        break;
                    default:
                        // if a property does not start with a valid sigil, skip
                        continue;
                    // other sigils may indicate other data types, but that's
                    // all for now
                }
                
                // if there's already a generic data property with the same
                // name, set its value instead of creating a new one, since
                // you're not really supposed to have duplicate properties
                var data_generic_instance = undefined;
                for (var k = 0; k < array_length(instance.generic_data); k++) {
                    var existing_generic = instance.generic_data[k];
                    if (string_lower(string_lettersdigits(existing_generic.name)) == string_lower(string_lettersdigits(base_property_name))) {
                        data_generic_instance = existing_generic;
                        break;
                    }
                }
                // otherwise, create one
                if (!data_generic_instance) {
                    data_generic_instance = new DataValue(base_property_name);
                    array_push(instance.generic_data, data_generic_instance);
                }
                
                data_generic_instance.type = property_type;
                data_generic_instance.value = property_value;
                data_generic_instance.type_guid = property_value_guid;
            }
            #endregion
        }
    }
    
    return z;
}