/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.AUDIO_BGM);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_bgm = ds_list_size(Stuff.all_bgm);
buffer_write(buffer, buffer_u16, n_bgm);

for (var i = 0; i < n_bgm; i++) {
    var bgm = Stuff.all_bgm[| i];
    
    serialize_save_generic(buffer, bgm);
    
    buffer_write(buffer, buffer_string, bgm.temp_name);
    buffer_write(buffer, buffer_f32, bgm.loop_start);
    buffer_write(buffer, buffer_f32, bgm.loop_end);
    
    if (file_exists(bgm.temp_name)) {
        var fbuffer = buffer_load(bgm.temp_name);
        var len = buffer_get_size(fbuffer);
        buffer_write(buffer, buffer_u32, len);
        buffer_copy(fbuffer, 0, len, buffer, buffer_tell(buffer));
        buffer_seek(buffer, buffer_seek_relative, len);
        buffer_delete(fbuffer);
    } else {
        buffer_write(buffer, buffer_u32, 0);
        buffer_write(buffer, buffer_u32, 0);
        debug("Audio file not found: " + string(bgm.GUID) + " [" + bgm.name + "]");
    }
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);