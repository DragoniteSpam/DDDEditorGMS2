function language_add(name) {
    var first = Stuff.all_languages[| 0];
    first = Stuff.all_localized_text[$ first];
    try {
        var new_lang_data = json_parse(json_stringify(first));
    } catch (e) {
        var new_lang_data = { };
    }
    Stuff.all_localized_text[$ name] = new_lang_data;
    var keys = variable_struct_get_names(new_lang_data);
    for (var i = 0; i < array_length(keys); i++) {
        new_lang_data[$ keys[i]] = "";
    }
    ds_list_add(Stuff.all_languages, name);
}

function language_remove(name) {
    if (ds_list_empty(Stuff.all_languages)) return;
    var index = ds_list_find_index(Stuff.all_languages, name);
    if (index + 1) {
        ds_list_delete(Stuff.all_languages, index);
        variable_struct_remove(Stuff.all_localized_text, name);
    }
}

function language_extract() {
    for (var l = 0; l < ds_list_size(Stuff.all_languages); l++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[| l]];
        #region data
        for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
            var datadata = Stuff.all_data[| i];
            if (datadata.type != DataTypes.DATA) continue;
            for (var j = 0; j < ds_list_size(datadata.properties); j++) {
                var property = datadata.properties[| j];
                if (property.type != DataTypes.STRING) continue;
                for (var k = 0; k < ds_list_size(datadata.instances); k++) {
                    var inst = datadata.instances[| k];
                    if (inst.name != "") lang[$ "Data." + inst.internal_name + ".@NAME@"] = inst.name;
                    if (inst.summary != "") lang[$ "Data." + inst.internal_name + ".@SUMMARY@"] = inst.summary;
                    for (var m = 0; m < ds_list_size(inst.values[| j]); m++) {
                        var text = inst.values[| j][| m];
                        if (text == "") continue;
                        lang[$ "Data." + inst.internal_name + "." + property.name + ((m > 0) ? "." + string(m) : "")] = text;
                    }
                }
            }
        }
        #endregion
        #region constants
        for (var i = 0; i < ds_list_size(Stuff.all_game_constants); i++) {
            var const = Stuff.all_game_constants[| i];
            if (const.type != DataTypes.STRING) continue;
            lang[$ "Const." + string(i) + "." + const.name] = const.value_string;
        }
        #endregion
        #region map generics
        for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
            var map = Stuff.all_maps[| i];
            for (var j = 0; j < ds_list_size(map.generic_data); j++) {
                var gen = map.generic_data[| j];
                if (gen.type != DataTypes.STRING) continue;
                lang[$ "Map." + map.internal_name + "." + gen.name] = gen.value_string;
            }
        }
        #endregion
        #region entity generics
        var scrape_entity_generics = function(map_container, lang) {
            for (var i = 0; i < ds_list_size(map_container.contents.all_entities); i++) {
                var entity = map_container.contents.all_entities[| i];
                for (var j = 0; j < ds_list_size(entity.generic_data); j++) {
                    var gen = entity.generic_data[| j];
                    if (gen.type != DataTypes.STRING) continue;
                    lang[$ "Map." + entity.name + "." + entity.REFID + "." + gen.name] = gen.value_string;
                }
            }
        };
        var scrape_entity_generics_buffer = function(buffer, map_container, lang) {
            var entities = serialize_load_map_contents_dynamic(buffer, map_container.version, undefined, false, true);
            for (var i = 0; i < array_length(entities); i++) {
                var entity = entities[i];
                for (var j = 0; j < ds_list_size(entity.generic_data); j++) {
                    var gen = entity.generic_data[| j];
                    if (gen.type != DataTypes.STRING) continue;
                    lang[$ "Map." + map_container.name + "." + entity.name + "." + entity.REFID + "." + gen.name] = gen.value_string;
                }
                instance_activate_object(entity);
                instance_destroy(entity);
            }
        };
        
        var map_warned = false;
        for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
            var map = Stuff.all_maps[| i];
            if (map.contents) {
                scrape_entity_generics(map, lang);
            } else {
                if (map.version >= DataVersions.MAP_SKIP_ADDRESSES) {
                    scrape_entity_generics_buffer(map.data_buffer, map, lang);
                } else if (!map_warned) {
                    dialog_create_notice(noone, "The map [c_blue]" + map.name + "[/c] is not of Version " + string(DataVersions.MAP_SKIP_ADDRESSES) + " or later, and will not have its text extracted. Update the map by opening and closing it.");
                    map_warned = true;
                }
            }
        }
        #endregion
        #region events
        for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
            var event = Stuff.all_events[| i];
            for (var j = 0; j < ds_list_size(event.nodes); j++) {
                var node = event.nodes[| j];
                for (var k = 0; k < ds_list_size(node.data); k++) {
                    lang[$ "Event." + event.name + "." + node.name + ".data." + string(k)] = node.data[| k];
                }
                if (node.type == EventNodeTypes.CUSTOM) {
                    var custom = guid_get(node.custom_guid);
                    for (var k = 0; k < ds_list_size(custom.types); k++) {
                        if (custom.types[| k][EventNodeCustomData.TYPE] == DataTypes.STRING) {
                            for (var l = 0; l < ds_list_size(node.custom_data[| k]); l++) {
                                lang[$ "Event." + event.name + "." + node.name + ".custom." + string(k) + "." + string(l)] = node.custom_data[| k][| l];
                            }
                        }
                    }
                }
            }
        }
        #endregion
    }
}