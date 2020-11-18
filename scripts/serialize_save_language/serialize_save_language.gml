function serialize_save_language(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.LANGUAGE_TEXT);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    buffer_write(buffer, buffer_u8, ds_list_size(Stuff.all_languages));
    for (var i = 0; i < ds_list_size(Stuff.all_languages); i++) {
        buffer_write(buffer, buffer_string, Stuff.all_languages[| i]);
    }
    
    var keys = variable_struct_get_names(Stuff.all_localized_text[$ Stuff.all_languages[| 0]]);
    buffer_write(buffer, buffer_u32, array_length(keys));
    for (var i = 0; i < array_length(keys); i++) {
        buffer_write(buffer, buffer_string, keys[i]);
    }
    
    for (var i = 0; i < ds_list_size(Stuff.all_languages); i++) {
        var lang = Stuff.all_localized_text[$ Stuff.all_languages[| i]];
        for (var j = 0; j < array_length(keys); j++) {
            buffer_write(buffer, buffer_string, lang[$ keys[i]]);
        }
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}