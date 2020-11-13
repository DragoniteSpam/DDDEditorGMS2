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