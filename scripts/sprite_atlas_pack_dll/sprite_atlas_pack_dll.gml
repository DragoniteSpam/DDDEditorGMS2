function sprite_atlas_pack_dll(sprite_array, padding, stride = 4, force_power_of_two = true) {
    static additional_bytes = 8;
    
    // each sprite is represented by four 4-byte floats
    var data_buffer = buffer_create(array_length(sprite_array) * 16, buffer_grow, 4);
    var sprite_lookup = __spal__setup(data_buffer, sprite_array, padding, force_power_of_two);
    var n = array_length(sprite_lookup);
    var bytes = array_length(sprite_lookup) * 4;
    
    __sprite_atlas_pack(buffer_get_address(data_buffer), bytes, stride);
    
    var maxx = buffer_peek(data_buffer, bytes * 4, buffer_s32);
    var maxy = buffer_peek(data_buffer, bytes * 4 + 4, buffer_s32);
    
    var results = __spal__cleanup(data_buffer, sprite_lookup, padding, maxx, maxy, force_power_of_two);
    buffer_delete(data_buffer);
    return results;
}