function serialize_save_language(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.LANGUAGE_TEXT);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    buffer_write(buffer, buffer_u8, array_length(Game.languages.names));
    for (var i = 0; i < array_length(Game.languages.names); i++) {
        buffer_write(buffer, buffer_string, Game.languages.names[i]);
    }
    
    var keys = variable_struct_get_names(Game.languages.text[$ Game.languages.names[0]]);
    buffer_write(buffer, buffer_u32, array_length(keys));
    for (var i = 0; i < array_length(keys); i++) {
        buffer_write(buffer, buffer_string, keys[i]);
    }
    
    for (var i = 0; i < array_length(Game.languages.names); i++) {
        var lang = Game.languages.text[$ Game.languages.names[i]];
        for (var j = 0; j < array_length(keys); j++) {
            buffer_write(buffer, buffer_string, lang[$ keys[j]]);
        }
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}