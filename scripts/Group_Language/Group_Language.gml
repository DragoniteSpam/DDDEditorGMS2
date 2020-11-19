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
    var existing_key_names = variable_struct_get_names(Stuff.all_localized_text[$ Stuff.all_languages[| 0]]);
    var existing_keys = { };
    for (var i = 0; i < array_length(existing_key_names); i++) {
        existing_keys[$ existing_key_names[i]] = true;
    }
    
    for (var lang_index = 0; lang_index < ds_list_size(Stuff.all_languages); lang_index++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[| lang_index]];
        
        #region data
        for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
            var datadata = Stuff.all_data[| i];
            if (datadata.type != DataTypes.DATA || !!(datadata.flags & DataDataFlags.NO_LOCALIZE)) continue;
            for (var j = 0; j < ds_list_size(datadata.properties); j++) {
                var property = datadata.properties[| j];
                if (property.type != DataTypes.STRING || !!(property.flags & DataPropertyFlags.NO_LOCALIZE)) continue;
                for (var k = 0; k < ds_list_size(datadata.instances); k++) {
                    var inst = datadata.instances[| k];
                    if (inst.name != "") {
                        var key = "Data." + inst.internal_name + ".@NAME@";
                        lang[$ key] = inst.name;
                        existing_keys[$ key] = false;
                    }
                    if (inst.summary != "") {
                        var key = "Data." + inst.internal_name + ".@SUMMARY@";
                        lang[$ key] = inst.summary;
                        existing_keys[$ key] = false;
                    }
                    for (var m = 0; m < ds_list_size(inst.values[| j]); m++) {
                        var text = inst.values[| j][| m];
                        if (text == "") continue;
                        var key = "Data." + inst.internal_name + "." + property.name + ((m > 0) ? "." + string(m) : "");
                        lang[$ key] = text;
                        existing_keys[$ key] = false;
                    }
                }
            }
        }
        #endregion
        #region constants
        for (var i = 0; i < ds_list_size(Stuff.all_game_constants); i++) {
            var const = Stuff.all_game_constants[| i];
            if (const.type != DataTypes.STRING) continue;
            var key = "Const." + string(i) + "." + const.name;
            lang[$ key] = const.value_string;
            existing_keys[$ key] = false;
        }
        #endregion
        #region map generics
        for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
            var map = Stuff.all_maps[| i];
            for (var j = 0; j < ds_list_size(map.generic_data); j++) {
                var gen = map.generic_data[| j];
                if (gen.type != DataTypes.STRING) continue;
                var key = "Map." + map.internal_name + "." + gen.name;
                lang[$ key] = gen.value_string;
                existing_keys[$ key] = false;
            }
        }
        #endregion
        #region entity generics
        var map_warned = false;
        for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
            var map = Stuff.all_maps[| i];
            if (map.contents) {
                for (var i = 0; i < ds_list_size(map.contents.all_entities); i++) {
                    var entity = map.contents.all_entities[| i];
                    for (var j = 0; j < ds_list_size(entity.generic_data); j++) {
                        var gen = entity.generic_data[| j];
                        if (gen.type != DataTypes.STRING) continue;
                        var key = "Map." + entity.name + "." + entity.REFID + "." + gen.name;
                        lang[$ key] = gen.value_string;
                        existing_keys[$ key] = false;
                    }
                }
            } else {
                if (map.version >= DataVersions.MAP_SKIP_ADDRESSES) {
                    var entities = serialize_load_map_contents_dynamic(map.data_buffer, map.version, undefined, false, true);
                    for (var i = 0; i < array_length(entities); i++) {
                        var entity = entities[i];
                        for (var j = 0; j < ds_list_size(entity.generic_data); j++) {
                            var gen = entity.generic_data[| j];
                            if (gen.type != DataTypes.STRING) continue;
                            var key = "Map." + map.name + "." + entity.name + "." + entity.REFID + "." + gen.name;
                            lang[$ key] = gen.value_string;
                            existing_keys[$ key] = false;
                        }
                        instance_activate_object(entity);
                        instance_destroy(entity);
                    }
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
                switch (node.type) {
                    case EventNodeTypes.TEXT:
                    case EventNodeTypes.SHOW_SCROLLING_TEXT:
                    case EventNodeTypes.SHOW_CHOICES:
                        for (var k = 0; k < ds_list_size(node.data); k++) {
                            var key = "Event." + event.name + "." + node.name + ".data." + string(k);
                            lang[$ key] = node.data[| k];
                            existing_keys[$ key] = false;
                        }
                        break;
                    case EventNodeTypes.CUSTOM:
                        var custom = guid_get(node.custom_guid);
                        for (var k = 0; k < ds_list_size(custom.types); k++) {
                            if (custom.types[| k][EventNodeCustomData.TYPE] == DataTypes.STRING) {
                                for (var l = 0; l < ds_list_size(node.custom_data[| k]); l++) {
                                    var key = "Event." + event.name + "." + node.name + ".custom." + string(k) + "." + string(l);
                                    lang[$ key] = node.custom_data[| k][| l];
                                    existing_keys[$ key] = false;
                                }
                            }
                        }
                        break;
                }
            }
        }
        #endregion
    }
    
    for (var i = 0; i < array_length(existing_key_names); i++) {
        if (existing_keys[$ existing_key_names[i]]) {
            for (var lang_index = 0; lang_index < ds_list_size(Stuff.all_languages); lang_index++) {
                variable_struct_remove(Stuff.all_localized_text[$ Stuff.all_languages[| lang_index]], existing_key_names[i]);
            }
        }
    }
}

function language_refresh_ui() {
    var ui = Stuff.text.ui;
    ui_list_clear(ui.el_language_text);
    for (var lang_index = 0; lang_index < ds_list_size(Stuff.all_languages); lang_index++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[| lang_index]];
        var all_keys = variable_struct_get_names(lang);
        array_sort(all_keys, true);
        for (var i = 0; i < array_length(all_keys); i++) {
            var base_text = lang[$ all_keys[i]];
            if (lang_index == 0) {
                ds_list_add(ui.el_language_text.entries, all_keys[i]);
            }
        }
    }
}