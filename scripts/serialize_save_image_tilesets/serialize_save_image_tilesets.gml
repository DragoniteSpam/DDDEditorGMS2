function serialize_save_image_tilesets(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.IMAGE_TILESET);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var n_tilesets = ds_list_size(Stuff.all_graphic_tilesets);
    buffer_write(buffer, buffer_u16, n_tilesets);
    
    for (var i = 0; i < n_tilesets; i++) {
        var ts = Stuff.all_graphic_tilesets[| i];
        
        // don't use save_generic here because flags is overridden and is now
        // an array, which will break things
        buffer_write(buffer, buffer_string, ts.name);
        buffer_write(buffer, buffer_string, ts.internal_name);
        buffer_write(buffer, buffer_string, ts.summary);
        buffer_write(buffer, buffer_datatype, ts.GUID);
        
        buffer_write(buffer, buffer_string, ts.source_filename);
        
        // stash the sprite in the buffer (via surface)
        buffer_write_sprite(buffer, ts.picture);
        buffer_write(buffer, buffer_u16, ts.hframes);
        buffer_write(buffer, buffer_u16, ts.vframes);
        
        for (var j = 0; j < ts.hframes; j++) {
            for (var k = 0; k < ts.vframes; k++) {
                buffer_write(buffer, buffer_u32, ts.flags[j][k]);
            }
        }
        
        buffer_write(buffer, buffer_u16, ts.width);
        buffer_write(buffer, buffer_u16, ts.height);
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}