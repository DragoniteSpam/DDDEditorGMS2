function sprite_atlas_pack_dll(sprite_array, padding, stride = 4) {
    static additional_bytes = 8;
    
    // each sprite is represented by four 4-byte floats
    var data_buffer = buffer_create(array_length(sprite_array) * 16, buffer_grow, 4);
    var sprite_lookup = __spal__setup(data_buffer, sprite_array, padding);
    var n = array_length(sprite_lookup);
    
    __sprite_atlas_pack(buffer_get_address(data_buffer), buffer_get_size(data_buffer) - additional_bytes, stride);
    
    var maxx = buffer_peek(data_buffer, buffer_get_size(data_buffer) - 8, buffer_s32);
    var maxy = buffer_peek(data_buffer, buffer_get_size(data_buffer) - 4, buffer_s32);
    
    var results = __spal__cleanup(data_buffer, sprite_lookup, padding, maxx, maxy);
    buffer_delete(data_buffer);
    return results;
}