function language_add(name) {
    var first = Stuff.all_languages[0];
    first = Stuff.all_localized_text[$ first];
    var new_lang_data;
    try {
        new_lang_data = json_parse(json_stringify(first));
    } catch (e) {
        new_lang_data = { };
    }
    Stuff.all_localized_text[$ name] = new_lang_data;
    var keys = variable_struct_get_names(new_lang_data);
    for (var i = 0; i < array_length(keys); i++) {
        new_lang_data[$ keys[i]] = "";
    }
    array_push(Stuff.all_languages, name);
}

function language_remove(name) {
    if (array_length(Stuff.all_languages) == 0) return;
    var index = array_search(Stuff.all_languages, name);
    if (index + 1) {
        array_delete(Stuff.all_languages, index, 1);
        variable_struct_remove(Stuff.all_localized_text, name);
    }
}

function language_extract() {
    var existing_key_names = variable_struct_get_names(Stuff.all_localized_text[$ Stuff.all_languages[0]]);
    var existing_keys = { };
    for (var i = 0; i < array_length(existing_key_names); i++) {
        existing_keys[$ existing_key_names[i]] = true;
    }
    
    for (var lang_index = 0; lang_index < array_length(Stuff.all_languages); lang_index++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[lang_index]];
        
        #region data
        for (var i = 0; i < ds_list_size(Stuff.all_data); i++) {
            var datadata = Stuff.all_data[| i];
            if (datadata.type != DataTypes.DATA) continue;
            if (!!(datadata.flags & DataDataFlags.NO_LOCALIZE)) continue;
            for (var k = 0; k < ds_list_size(datadata.instances); k++) {
                var inst = datadata.instances[| k];
                if (!(datadata.flags & DataDataFlags.NO_LOCALIZE_NAME)) {
                    var key = "Data." + inst.internal_name + ".@NAME@";
                    lang[$ key] = (lang_index == 0) ? inst.name : ((lang[$ key] != undefined) ? lang[$ key] : "");
                    existing_keys[$ key] = false;
                }
                if (!(datadata.flags & DataDataFlags.NO_LOCALIZE_SUMMARY)) {
                    var key = "Data." + inst.internal_name + ".@SUMMARY@";
                    lang[$ key] = (lang_index == 0) ? inst.summary : ((lang[$ key] != undefined) ? lang[$ key] : "");
                    existing_keys[$ key] = false;
                }
                for (var j = 0; j < ds_list_size(datadata.properties); j++) {
                    var property = datadata.properties[| j];
                    if (property.type != DataTypes.STRING || !!(property.flags & DataPropertyFlags.NO_LOCALIZE)) continue;
                    for (var m = 0; m < ds_list_size(inst.values[| j]); m++) {
                        var text = inst.values[| j][| m];
                        if (text == "") continue;
                        var key = "Data." + inst.internal_name + "." + property.name + ((m > 0) ? "." + string(m) : "");
                        lang[$ key] = (lang_index == 0) ? text : ((lang[$ key] != undefined) ? lang[$ key] : "");
                        existing_keys[$ key] = false;
                    }
                }
            }
        }
        #endregion
        #region constants
        for (var i = 0; i < array_length(Game.all_game_constants); i++) {
            var const = Game.all_game_constants[i];
            if (const.type != DataTypes.STRING) continue;
            var key = "Const." + const.name;
            lang[$ key] = (lang_index == 0) ? const.value_string : ((lang[$ key] != undefined) ? lang[$ key] : "");
            existing_keys[$ key] = false;
        }
        #endregion
        #region map generics
        for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
            var map = Stuff.all_maps[| i];
            for (var j = 0; j < array_length(map.generic_data); j++) {
                var gen = map.generic_data[j];
                if (gen.type != DataTypes.STRING) continue;
                var key = "Map." + map.internal_name + "." + gen.name;
                lang[$ key] = (lang_index == 0) ? gen.value_string : ((lang[$ key] != undefined) ? lang[$ key] : "");
                existing_keys[$ key] = false;
            }
        }
        #endregion
        #region entity generics
        var map_warned = false;
        for (var i = 0; i < ds_list_size(Stuff.all_maps); i++) {
            var map = Stuff.all_maps[| i];
            if (map.contents) {
                for (var j = 0; j < ds_list_size(map.contents.all_entities); j++) {
                    var entity = map.contents.all_entities[| j];
                    for (var k = 0; k < array_length(entity.generic_data); k++) {
                        var gen = entity.generic_data[k];
                        if (gen.type != DataTypes.STRING) continue;
                        var key = "Map." + entity.name + "." + entity.REFID + "." + gen.name;
                        lang[$ key] = (lang_index == 0) ? gen.value_string : ((lang[$ key] != undefined) ? lang[$ key] : "");
                        existing_keys[$ key] = false;
                    }
                }
            } else {
                var entities = serialize_load_map_contents_dynamic(map.data_buffer, map.version, undefined, false, true);
                for (var j = 0; j < array_length(entities); j++) {
                    var entity = entities[j];
                    for (var k = 0; k < array_length(entity.generic_data); k++) {
                        var gen = entity.generic_data[k];
                        if (gen.type != DataTypes.STRING) continue;
                        var key = "Map." + map.name + "." + entity.name + "." + entity.REFID + "." + gen.name;
                        lang[$ key] = (lang_index == 0) ? gen.value_string : ((lang[$ key] != undefined) ? lang[$ key] : "");
                        existing_keys[$ key] = false;
                    }
                    instance_activate_object(entity);
                    instance_destroy(entity);
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
                            var key = "Event." + node.name + "." + string(node.GUID) + ".data." + string(k);
                            lang[$ key] = (lang_index == 0) ? node.data[| k] : ((lang[$ key] != undefined) ? lang[$ key] : "");
                            existing_keys[$ key] = false;
                        }
                        break;
                    case EventNodeTypes.CUSTOM:
                        var custom = guid_get(node.custom_guid);
                        for (var k = 0; k < ds_list_size(custom.types); k++) {
                            if (custom.types[| k][EventNodeCustomData.TYPE] == DataTypes.STRING) {
                                for (var l = 0; l < array_length(node.custom_data[k]); l++) {
                                    var key = "Event." + node.name + "." + string(node.GUID) + ".custom." + string(k) + "." + string(l);
                                    lang[$ key] = (lang_index == 0) ? node.custom_data[k][l] : ((lang[$ key] != undefined) ? lang[$ key] : "");
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
            for (var lang_index = 0; lang_index < array_length(Stuff.all_languages); lang_index++) {
                variable_struct_remove(Stuff.all_localized_text[$ Stuff.all_languages[lang_index]], existing_key_names[i]);
            }
        }
    }
    
    language_refresh_ui();
}

function language_refresh_ui() {
    var ui = Stuff.text.ui;
    ui.el_language_list.entries = Stuff.all_languages;
    ui_list_clear(ui.el_language_text);
    var all_keys = variable_struct_get_names(Stuff.all_localized_text[$ Stuff.all_languages[0]]);
    array_sort(all_keys, true);
    for (var i = 0; i < array_length(all_keys); i++) {
        ds_list_add(ui.el_language_text.entries, all_keys[i]);
    }
}

function language_set_default_text() {
    var default_lang = Stuff.all_localized_text[$ Stuff.all_languages[0]];
    var keys = variable_struct_get_names(default_lang);
    for (var i = 1; i < array_length(Stuff.all_languages); i++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[i]];
        for (var j = 0; j < array_length(keys); j++) {
            if (lang[$ keys[j]] == "") lang[$ keys[j]] = default_lang[$ keys[j]];
        }
    }
}