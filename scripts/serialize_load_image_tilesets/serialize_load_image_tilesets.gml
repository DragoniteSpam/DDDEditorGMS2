function serialize_load_image_tilesets(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    ds_list_clear_instances(Stuff.all_graphic_tilesets);
    gpu_set_state(Stuff.gpu_base_state);
    var n_tilesets = buffer_read(buffer, buffer_u16);
    
    for (var i = 0; i < n_tilesets; i++) {
        // don't use load_generic here because flags is now an array and that
        // will break things
        var name = buffer_read(buffer, buffer_string);
        var internal_name = buffer_read(buffer, buffer_string);
        var summary = buffer_read(buffer, buffer_string);
        var guid = buffer_read(buffer, buffer_get_datatype(version));
        
        var ts_name = buffer_read(buffer, buffer_string);
        
        var sprite = buffer_read_sprite(buffer);
        
        // all of the other things
        var n_autotiles = buffer_read(buffer, buffer_u8);
        var at_array = array_create(n_autotiles);
        var at_flags = array_create(n_autotiles);
        
        for (var j = 0; j < n_autotiles; j++) {
            // s16 because no tile is "noone"
            at_array[j] = buffer_read(buffer, buffer_s16);
            at_flags[j] = buffer_read(buffer, buffer_u32);
        }
        
        var ts = tileset_create(ts_name, at_array, sprite);
        
        ts.name = name;
        ts.internal_name = internal_name;
        ts.summary = summary;
        guid_set(ts, guid, true);
        
        ts.at_flags = at_flags;
        
        ts.hframes = buffer_read(buffer, buffer_u16);
        ts.vframes = buffer_read(buffer, buffer_u16);
        
        ts.flags = array_create_2d(ts.hframes, ts.vframes);
        for (var j = 0; j < ts.hframes; j++) {
            for (var k = 0; k < ts.vframes; k++) {
                ts.flags[@ j][@ k] = buffer_read(buffer, buffer_u32);
            }
        }
    }
}