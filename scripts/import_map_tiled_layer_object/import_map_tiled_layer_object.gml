/// @param json
/// @param ts-columns
/// @param z
/// @param [alpha]
/// @param [x]
/// @param [y]
/// @param [tiled-cache]
function import_map_tiled_layer_object() {
    var json = argument[0];
    var columns = argument[1];
    var z = argument[2];
    var alpha = (argument_count > 3) ? argument[3] : 1;
    var xx = (argument_count > 4) ? argument[4] : 0;
    var yy = (argument_count > 5) ? argument[5] : 0;
    var tiled_cache = (argument_count > 6) ? argument[6] : noone;
    var zz = z;
    var layer_flag = 0;
    
    var map = Stuff.map.active_map;
    
    var layer_objects = json[? "objects"];
    var layer_name = json[? "name"];
    var layer_alpha = json[? "opacity"];
    var layer_visible = json[? "visible"];
    var layer_data_x = json[? "x"];
    var layer_data_y = json[? "y"];
    var layer_base_z = z;
    var layer_properties = json[? "properties"];
    if (layer_properties) {
        for (var i = 0; i < ds_list_size(layer_properties); i++) {
            var property_data = layer_properties[| i];
            var property_name = property_data[? "name"];
            if (string_copy(property_name, 1, 4) == "Tag_") {
                var imported = string_lettersdigits(string_lower(string(property_data[? "value"])));
                for (var j = 0; j < array_length(Stuff.all_asset_flags); j++) {
                    if (string_lettersdigits(string_lower(Stuff.all_asset_flags[j])) == imported) {
                        layer_flag |= (1 << j);
                        break;
                    }
                }
            }
        }
    }
    
    var tmx_cache = tiled_cache[? "&tmx-ids"];
    
    for (var i = 0; i < ds_list_size(layer_objects); i++) {
        var object = layer_objects[| i];
        var obj_id = object[? "id"];
        var obj_x = object[? "x"];
        var obj_y = object[? "y"];
        
        if (!is_clamped((xx + obj_x) / TILE_WIDTH, 0, map.xx - 1)) continue;
        if (!is_clamped((yy + obj_y) / TILE_HEIGHT, 0, map.yy - 1)) continue;
        if (!is_clamped(zz, 0, map.zz - 1)) continue;
        
        var obj_gid_local = object[? "gid"];
        var obj_name = object[? "name"];
        var obj_template = object[? "template"];
        var obj_properties = object[? "properties"];
        var obj_type = object[? "type"];
        var obj_visible = object[? "visible"];
        var obj_width = object[? "width"];
        var obj_height = object[? "height"];
        
        // if the layer has a tag assigned to it, instead of creating an instance
        // of a mesh or whatever, convert its area to a tag
        if (layer_flag) {
            var x1 = obj_x div TILE_WIDTH;
            var y1 = obj_y div TILE_HEIGHT;
            var x2 = x1 + (obj_width div TILE_WIDTH);
            var y2 = y1 + (obj_height div TILE_HEIGHT);
            for (var j = x1; j < x2; j++) {
                for (var k = y1; k < y2; k++) {
                    map.SetFlag(j, k, zz, layer_flag);
                }
            }
            continue;
        }
        
        if ((obj_template == undefined)) {
            var data_template = noone;
            var data_template_root = noone;
        } else {
            var data_template_root = import_map_tiled_get_cached_object(tiled_cache, obj_template);
            var data_template = data_template_root[? "object"];
        }
        
        if (!data_template) {
            if (obj_gid_local == undefined) continue;
            if (obj_name == undefined) continue;
            if (obj_type == undefined) continue;
            if (obj_visible == undefined) continue;
            if (obj_width == undefined) continue;
            if (obj_height == undefined) continue;
            
            var data_gid = obj_gid_local;
            var data_name = obj_name;
            var data_type = obj_type;
            var data_visible = obj_visible;
            var data_width = obj_width;
            var data_height = obj_height;
        } else {
            var data_name = (obj_name == undefined) ? data_template[? "name"] : obj_name;
            var data_type = (obj_type == undefined) ? data_template[? "type"] : obj_type;
            var data_visible = (obj_visible == undefined) ? data_template[? "visible"] : obj_visible;
            var data_width = (obj_width == undefined) ? data_template[? "width"] : obj_width;
            var data_height = (obj_height == undefined) ? data_template[? "height"] : obj_height;
            
            // because this gid system makes everything extremely fun and enjoyable to work with
            if (obj_gid_local == undefined) {
                var ts_object = data_template_root[? "tileset"];
                var ts_base_list = tiled_cache[? "%tilesets"];
                for (var j = 0; j < ds_list_size(ts_base_list); j++) {
                    var ts_data = ts_base_list[| j];
                    if (string_count(ts_data[? "source"], ts_object[? "source"]) > 0) {
                        var data_gid = ts_data[? "firstgid"] + data_template[? "gid"] - 1 /* i really don't like things that are 1-indexed */;
                        break;
                    }
                }
            } else {
                var data_gid = obj_gid_local;
            }
        }
        
        // merging the property maps does not sound like my idea of a fun time, but not doing it would be even worse
        var data_properties = ds_map_create();
        
        // the properties given to the instantiated object go first
        if (obj_properties != undefined) {
            for (var j = 0; j < ds_list_size(obj_properties); j++) {
                var given = obj_properties[| j];
                var property = ds_map_create();
                property[? "name"] = given[? "name"];
                property[? "value"] = given[? "value"];
                ds_map_add_map(data_properties, given[? "name"], property);
            }
        }
        // the properties of the template go last - if any can be found
        if (data_template && data_template[? "properties"] != undefined) {
            var template_properties = data_template[? "properties"];
            if (template_properties != undefined) {
                for (var j = 0; j < ds_list_size(template_properties); j++) {
                    var given = template_properties[| j];
                    if (!ds_map_exists(data_properties, given[? "name"])) {
                        var property = ds_map_create();
                        property[? "name"] = given[? "name"];
                        property[? "value"] = given[? "value"];
                        ds_map_add_map(data_properties, given[? "name"], property);
                    }
                }
            }
        }
        
        // extract the information about the tile the object uses
        var gid_cache = tiled_cache[? "&gid"];
        var gid_to_image_name = gid_cache[? data_gid];
        
        if (gid_to_image_name == undefined) {
            var ts_json_data = noone;
            var ts_base_list = tiled_cache[? "%tilesets"];
            for (var j = ds_list_size(ts_base_list) - 1; j >= 0; j--) {
                var ts_data = ts_base_list[| j];
                if (ts_data[? "firstgid"] <= data_gid) {
                    ts_json_data = ts_base_list[| j];
                    break;
                }
            }
            
            // i do NOT want to go through this every time so i'm going to cache the result
            // when i can since the gids are [waves hands] global
            var tileset_data = import_map_tiled_get_cached_tileset(tiled_cache, ts_json_data[? "source"]);
            var tileset_tile_data = tileset_data[? "tiles"];
            var tile_id = data_gid - ts_json_data[? "firstgid"];
            for (var j = 0; j < ds_list_size(tileset_tile_data); j++) {
                var tileset_tile_data_object = tileset_tile_data[| j];
                if (tileset_tile_data_object[? "id"] == tile_id) {
                    gid_to_image_name = filename_name(filename_change_ext(tileset_tile_data_object[? "image"], ""));
                    ds_map_add(gid_cache, data_gid, gid_to_image_name);
                }
            }
            var tileset_tile_individual = tileset_tile_data[| data_gid - ts_json_data[? "firstgid"]];
        }
        
        var instance = noone;
        var update = false;
        
        switch (string_lower(data_type)) {
            case "pawn":
            #region load pawn
                var pr_static = data_properties[? "Static?"];
                
                if (pr_static == undefined) break;
                
                pr_static = pr_static[? "value"];
                
                var thing = internal_name_get(gid_to_image_name);
                
                if (tmx_cache[? obj_id]) {
                    instance = tmx_cache[? obj_id];
                    map.Remove(instance);
                    if (thing) {
                        instance.overworld_sprite = thing.GUID;
                        // position for NPCs is at -1 because of where the origin for sprites is in Tiled
                        map.Add(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT - 1, zz, false, false);
                    } else {
                        instance_activate_object(thing);
                        instance_destroy(thing);
                        updated = true;
                    }
                } else if (thing) {
                    instance = instance_create_pawn();
                    instance.tmx_id = obj_id;
                    instance.overworld_sprite = thing.GUID;
                    // position for NPCs is at -1 because of where the origin for sprites is in Tiled
                    map.Add(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT - 1, zz);
                } else {
                    wtf("GID not found: " + gid_to_image_name);
                }
                break;
            #endregion
            case "mesh":
            #region load mesh
                var pr_static = data_properties[? "Static?"];
                var pr_offset_x = data_properties[? "OffsetX"];
                var pr_offset_y = data_properties[? "OffsetY"];
                
                if (pr_static == undefined) break;
                pr_offset_x = (pr_offset_x == undefined) ? 0 : pr_offset_x[? "value"];
                pr_offset_y = (pr_offset_y == undefined) ? 0 : pr_offset_y[? "value"];
                
                pr_static = pr_static[? "value"];
                
                var pr_mesh_data = internal_name_get(gid_to_image_name);
                if (pr_mesh_data) {
                    if (tmx_cache[? obj_id]) {
                        instance = tmx_cache[? obj_id];
                        update = true;
                        // The entity only needs to be relocated; it doesn't need to be removed from
                        // the lists, or re-added later, because that would take a lot of time
                        map.Remove(instance);
                        map.Add(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT, zz, false, false);
                    } else {
                        instance = instance_create_mesh(pr_mesh_data);
                        instance.tmx_id = obj_id;
                        map.Add(instance, (xx + obj_x) div TILE_WIDTH, (yy + obj_y) div TILE_HEIGHT, zz);
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
            var pr_cutscene_entrypoint = data_properties[? "CutsceneEntrypoint"];
            var pr_autorun_entrypoint = data_properties[? "AutorunEntrypoint"];
            pr_cutscene_entrypoint = pr_cutscene_entrypoint ? event_get_node_global(pr_cutscene_entrypoint[? "value"]) : undefined;
            pr_autorun_entrypoint = pr_autorun_entrypoint ? event_get_node_global(pr_autorun_entrypoint[? "value"]) : undefined;
            // arrays don't have a truth value apparently
            if (pr_cutscene_entrypoint != undefined) {
                var page = undefined;
                for (var j = 0; j < array_length(instance.object_events); j++) {
                    if (instance.object_events[j].trigger == 0x01) {
                        page = instance.object_events[j];
                        break;
                    }
                }
                if (!page) {
                    array_push(instance.object_events, new InstantiatedEvent(""));
                }
                page.name = "Conversation:" + pr_cutscene_entrypoint[1].name;
                page.trigger = 0x01;   // action button
                page.event_entrypoint = pr_cutscene_entrypoint[1].GUID;
            }
            if (pr_autorun_entrypoint != undefined) {
                var page = undefined;
                for (var j = 0; j < array_length(instance.object_events); j++) {
                    if (instance.object_events[j].trigger == 0x08) {
                        page = instance.object_events[j];
                        break;
                    }
                }
                if (!page) {
                    array_push(instance.object_events, new InstantiatedEvent(""));
                }
                page.name = "Autorun:" + pr_autorun_entrypoint[1].name;
                page.trigger = 0x08;   // autorun
                page.event_entrypoint = pr_autorun_entrypoint[1].GUID;
            }
            #endregion
            
            #region generic properties
            var property_list = ds_map_to_list(data_properties);
            for (var j = 0; j < ds_list_size(property_list); j++) {
                var property = data_properties[? property_list[| j]];
                var property_name = property[? "name"];
                
                var property_value_real = 0;
                var property_value_int = 0;
                var property_value_string = "";
                var property_value_bool = false;
                var property_value_color = c_black;
                var property_value_type_guid = NULL;
                var property_value_data = 0;
                var property_type = DataTypes.INT;
                var base_property_name = "";
                var accept = true;
                
                switch (string_char_at(property_name, 1)) {
                    case "@":
                        var data = internal_name_get(property[? "value"]);
                        if (data) {
                            base_property_name = string_replace(property_name, "@", "");
                            property_value_data = data.GUID;
                            property_value_type_guid = guid_get(data.base_guid).GUID;
                            property_type = DataTypes.DATA;
                        } else {
                            wtf("internal name not found - " + property[? "value"]);
                        }
                        break;
                    case "$":
                        base_property_name = string_replace(property_name, "$", "");
                        property_value_string = property[? "value"];
                        property_type = DataTypes.STRING;
                        break;
                    case "#":
                        base_property_name = string_replace(property_name, "#", "");
                        property_value_string = property[? "value"];
                        property_type = DataTypes.FLOAT;
                        break;
                    default:
                        // if a property does not start with a valid sigil, skip it
                        accept = false;
                        break;
                    // other sigils may indicate other data types, but that's all for now
                }
                
                if (accept) {
                    // if there's already a generic data property with the same name, set its
                    // value instead of creating a new one, since you're not really supposed to
                    // have duplicate generic properties
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
                    data_generic_instance.value_real = property_value_real;
                    data_generic_instance.value_int = property_value_int;
                    data_generic_instance.value_string = property_value_string;
                    data_generic_instance.value_bool = property_value_bool;
                    data_generic_instance.value_color = property_value_color;
                    data_generic_instance.value_data = property_value_data;
                    data_generic_instance.value_type_guid = property_value_type_guid;
                    data_generic_instance.type = property_type;
                }
            }
            ds_list_destroy(property_list);
            #endregion
        }
    
        ds_map_destroy(data_properties);
    }

    return z;
}