function serialize_save_se(buffer) {
    buffer_write(buffer, buffer_u32, SerializeThings.AUDIO_SE);
    var addr_next = buffer_tell(buffer);
    buffer_write(buffer, buffer_u64, 0);
    
    var n_se = ds_list_size(Game.audio.se);
    buffer_write(buffer, buffer_u16, n_se);
    
    for (var i = 0; i < n_se; i++) {
        var se = Game.audio.se[| i];
        
        serialize_save_generic(buffer, se);
        
        buffer_write(buffer, buffer_string, se.temp_name);
        
        if (file_exists(se.temp_name)) {
            var fbuffer = se.GetBuffer();
            var len = buffer_get_size(fbuffer);
            buffer_write(buffer, buffer_u32, len);
            buffer_copy(fbuffer, 0, len, buffer, buffer_tell(buffer));
            buffer_seek(buffer, buffer_seek_relative, len);
            buffer_delete(fbuffer);
        } else {
            buffer_write(buffer, buffer_u32, 0 /* length */);
            buffer_write(buffer, buffer_u32, 0 /* this is important for something i think */);
            wtf("Audio file not found: " + string(se.GUID) + " [" + se.name + "]");
        }
        
        buffer_write(buffer, buffer_u32, se.fmod_rate);
    }
    
    buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));
    
    return buffer_tell(buffer);
}