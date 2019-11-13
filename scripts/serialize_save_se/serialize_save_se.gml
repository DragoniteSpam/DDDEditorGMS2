/// @param buffer

var buffer = argument0;

buffer_write(buffer, buffer_datatype, SerializeThings.AUDIO_SE);
var addr_next = buffer_tell(buffer);
buffer_write(buffer, buffer_u64, 0);

var n_se = ds_list_size(Stuff.all_se);
buffer_write(buffer, buffer_u16, n_se);

for (var i = 0; i < n_se; i++) {
    var se = Stuff.all_se[| i];
    
    serialize_save_generic(buffer, se);
    
    buffer_write(buffer, buffer_string, se.temp_name);
    if (file_exists(se.temp_name)) {
        var fbuffer = buffer_load(se.temp_name);
        var len = buffer_get_size(fbuffer);
        buffer_write(buffer, buffer_u32, len);
        buffer_copy(fbuffer, 0, len, buffer, buffer_tell(buffer));
        buffer_seek(buffer, buffer_seek_relative, len);
        buffer_delete(fbuffer);
    } else {
        buffer_write(buffer, buffer_u32, 0);
        buffer_write(buffer, buffer_u32, 0);
        debug("Audio file not found: " + string(se.GUID) + " [" + se.name + "]");
    }
}

buffer_poke(buffer, addr_next, buffer_u64, buffer_tell(buffer));

return buffer_tell(buffer);