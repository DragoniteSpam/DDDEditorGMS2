function serialize_load_image_tilesets(buffer, version) {
    var addr_next = buffer_read(buffer, buffer_u64);
    
    ds_list_clear_instances(Game.graphics.tilesets);
    gpu_set_state(Stuff.gpu_base_state);
    var n_tilesets = buffer_read(buffer, buffer_u16);
    
    for (var i = 0; i < n_tilesets; i++) {
        // don't use load_generic here because flags is now an array and that
        // will break things
        var name = buffer_read(buffer, buffer_string);
        var internal_name = buffer_read(buffer, buffer_string);
        var summary = buffer_read(buffer, buffer_string);
        var guid = buffer_read(buffer, buffer_datatype);
        
        var ts_source_name = buffer_read(buffer, buffer_string);
        var sprite = buffer_read_sprite(buffer);
        var ts = tileset_create(ts_source_name, sprite);
        
        ts.name = name;
        ts.summary = summary;
        guid_set(ts, guid, true);
        internal_name_set(ts, internal_name, false);
        
        ts.hframes = buffer_read(buffer, buffer_u16);
        ts.vframes = buffer_read(buffer, buffer_u16);
        
        ts.flags = array_create_2d(ts.hframes, ts.vframes);
        for (var j = 0; j < ts.hframes; j++) {
            for (var k = 0; k < ts.vframes; k++) {
                ts.flags[@ j][@ k] = buffer_read(buffer, buffer_u32);
            }
        }
        
        ts.width = buffer_read(buffer, buffer_u16);
        ts.height = buffer_read(buffer, buffer_u16);
    }
}