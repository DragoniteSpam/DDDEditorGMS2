/// @param buffer

buffer_write(argument0, buffer_datatype, SerializeThings.AUDIO_SE);

var n_se = ds_list_size(Stuff.all_se);
buffer_write(argument0, buffer_u16, n_se);

for (var i = 0; i < n_se; i++) {
    var se = Stuff.all_se[| i];
    
    serialize_save_generic(argument0, se);
    
    buffer_write(argument0, buffer_string, se.temp_name);
    if (file_exists(se.temp_name)) {
        var fbuffer = buffer_load(se.temp_name);
        var len = buffer_get_size(fbuffer);
        buffer_write(argument0, buffer_u32, len);
        buffer_copy(fbuffer, 0, len, argument0, buffer_tell(argument0));
        buffer_seek(argument0, buffer_seek_relative, len);
        buffer_delete(fbuffer);
    } else {
        buffer_write(argument0, buffer_u32, 0);
        buffer_write(argument0, buffer_u32, 0);
        debug("Audio file not found: " + string(se.GUID) + " [" + se.name + "]");
    }
}