function language_add(name) {
    var first = Game.languages.names[0];
    first = Game.languages.text[$ first];
    var new_lang_data;
    try {
        new_lang_data = json_parse(json_stringify(first));
    } catch (e) {
        new_lang_data = { };
    }
    Game.languages.text[$ name] = new_lang_data;
    var keys = variable_struct_get_names(new_lang_data);
    for (var i = 0; i < array_length(keys); i++) {
        new_lang_data[$ keys[i]] = "";
    }
    array_push(Game.languages.names, name);
}

function language_remove(name) {
    if (array_length(Game.languages.names) == 0) return;
    var index = array_get_index(Game.languages.names, name);
    if (index + 1) {
        array_delete(Game.languages.names, index, 1);
        variable_struct_remove(Game.languages.text, name);
    }
}

function language_extract() {
    var existing_key_names = variable_struct_get_names(Game.languages.text[$ Game.languages.names[0]]);
    var existing_keys = { };
    var map_extract_warned = false;
    for (var i = 0; i < array_length(existing_key_names); i++) {
        existing_keys[$ existing_key_names[i]] = true;
    }
    
    for (var lang_index = 0; lang_index < array_length(Game.languages.names); lang_index++) {
        var lang = Game.languages.text[$ Game.languages.names[lang_index]];
        
        #region data
        for (var i = 0; i < array_length(Game.data); i++) {
            var datadata = Game.data[i];
            if (datadata.type != DataTypes.DATA) continue;
            if (!!(datadata.flags & DataDataFlags.NO_LOCALIZE)) continue;
            for (var k = 0; k < array_length(datadata.instances); k++) {
                var inst = datadata.instances[k];
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
                for (var j = 0; j < array_length(datadata.properties); j++) {
                    var property = datadata.properties[j];
                    if (property.type != DataTypes.STRING || !!(property.flags & DataPropertyFlags.NO_LOCALIZE)) continue;
                    for (var m = 0; m < array_length(inst.values[j]); m++) {
                        var text = inst.values[j][m];
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
        for (var i = 0; i < array_length(Game.vars.constants); i++) {
            var const = Game.vars.constants[i];
            if (const.type != DataTypes.STRING) continue;
            var key = "Const." + const.name;
            lang[$ key] = (lang_index == 0) ? const.value : ((lang[$ key] != undefined) ? lang[$ key] : "");
            existing_keys[$ key] = false;
        }
        #endregion
        #region map generics
        for (var i = 0; i < array_length(Game.maps); i++) {
            var map = Game.maps[i];
            for (var j = 0; j < array_length(map.generic_data); j++) {
                var gen = map.generic_data[j];
                if (gen.type != DataTypes.STRING) continue;
                var key = "Map." + map.internal_name + "." + gen.name;
                lang[$ key] = (lang_index == 0) ? gen.value : ((lang[$ key] != undefined) ? lang[$ key] : "");
                existing_keys[$ key] = false;
            }
        }
        #endregion
        #region entity generics
        for (var i = 0; i < array_length(Game.maps); i++) {
            var map = Game.maps[i];
            if (map.contents) {
                for (var j = 0; j < ds_list_size(map.contents.all_entities); j++) {
                    var entity = map.contents.all_entities[| j];
                    for (var k = 0; k < array_length(entity.generic_data); k++) {
                        var gen = entity.generic_data[k];
                        if (gen.type != DataTypes.STRING) continue;
                        var key = "Map." + entity.name + "." + entity.REFID + "." + gen.name;
                        lang[$ key] = (lang_index == 0) ? gen.value : ((lang[$ key] != undefined) ? lang[$ key] : "");
                        existing_keys[$ key] = false;
                    }
                }
            } else {
                if (!map_extract_warned) {
                    emu_dialog_notice("To do - scan maps other than the currently loaded one for strings");
                    map_extract_warned = true;
                }
                continue;
            }
        }
        #endregion
        #region events
        for (var i = 0; i < array_length(Game.events.events); i++) {
            var event = Game.events.events[i];
            for (var j = 0; j < array_length(event.nodes); j++) {
                var node = event.nodes[j];
                switch (node.type) {
                    case EventNodeTypes.TEXT:
                    case EventNodeTypes.SHOW_SCROLLING_TEXT:
                    case EventNodeTypes.SHOW_CHOICES:
                        for (var k = 0; k < array_length(node.data); k++) {
                            var key = "Event." + node.name + "." + string(node.GUID) + ".data." + string(k);
                            lang[$ key] = (lang_index == 0) ? node.data[k] : ((lang[$ key] != undefined) ? lang[$ key] : "");
                            existing_keys[$ key] = false;
                        }
                        break;
                    case EventNodeTypes.CUSTOM:
                        var custom = guid_get(node.custom_guid);
                        for (var k = 0; k < array_length(custom.types); k++) {
                            if (custom.types[k].type == DataTypes.STRING) {
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
            for (var lang_index = 0; lang_index < array_length(Game.languages.names); lang_index++) {
                variable_struct_remove(Game.languages.text[$ Game.languages.names[lang_index]], existing_key_names[i]);
            }
        }
    }
    
    language_refresh_ui();
}

function language_refresh_ui() {
    var ui = Stuff.text.ui;
    ui.el_language_list.entries = Game.languages.names;
    ui_list_clear(ui.el_language_text);
    var all_keys = variable_struct_get_names(Game.languages.text[$ Game.languages.names[0]]);
    array_sort(all_keys, true);
    for (var i = 0; i < array_length(all_keys); i++) {
        ds_list_add(ui.el_language_text.entries, all_keys[i]);
    }
}

function language_set_default_text() {
    var default_lang = Game.languages.text[$ Game.languages.names[0]];
    var keys = variable_struct_get_names(default_lang);
    for (var i = 1; i < array_length(Game.languages.names); i++) {
        var lang = Game.languages.text[$ Game.languages.names[i]];
        for (var j = 0; j < array_length(keys); j++) {
            if (lang[$ keys[j]] == "") lang[$ keys[j]] = default_lang[$ keys[j]];
        }
    }
}