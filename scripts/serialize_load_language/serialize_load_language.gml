function serialize_load_language(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    ds_list_clear(Stuff.all_languages);
    
    var n_languages = buffer_read(buffer, buffer_u8);
    repeat (n_languages) {
        var lang_name = buffer_read(buffer, buffer_string);
        ds_list_add(Stuff.all_languages, lang_name);
        Stuff.all_localized_text[$ lang_name] = { };
    }
    
    var n_keys = buffer_read(buffer, buffer_u32);
    var keys = array_create(n_keys);
    for (var i = 0; i < n_keys; i++) {
        keys[i] = buffer_read(buffer, buffer_string);
    }
    
    for (var i = 0; i < n_languages; i++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[| i]];
        for (var j = 0; j < n_keys; j++) {
            lang[$ keys[j]] = buffer_read(buffer, buffer_string);
        }
    }
    
    language_refresh_ui();
}