function sprite_atlas_pack_dll(sprite_array, padding, borders) {
    static additional_bytes = 8;
    
    var data_buffer = buffer_create(array_length(sprite_array) << 4, buffer_grow, 4);
    var sprite_lookup = __spal__setup(data_buffer, sprite_array, padding, 0);
    var n = array_length(sprite_lookup);
    
    __sprite_atlas_pack(buffer_get_address(data_buffer), buffer_get_size(data_buffer) - additional_bytes);
    
    var maxx = buffer_peek(data_buffer, buffer_get_size(data_buffer) - 8, buffer_s32);
    var maxy = buffer_peek(data_buffer, buffer_get_size(data_buffer) - 4, buffer_s32);
    
    var results = __spal__cleanup(data_buffer, sprite_lookup, padding, borders, maxx, maxy);
    buffer_delete(data_buffer);
    return results;
}