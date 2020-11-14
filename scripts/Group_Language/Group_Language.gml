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
                        lang[$ "Data." + inst.internal_name + "." + property.name + "." + string(m)] = text;
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
    }
}