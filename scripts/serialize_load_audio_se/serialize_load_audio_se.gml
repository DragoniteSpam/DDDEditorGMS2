/// @param buffer
/// @param version
function serialize_load_audio_se(argument0, argument1) {

    var buffer = argument0;
    var version = argument1;

    var addr_next = buffer_read(buffer, buffer_u64);

    var n_se = buffer_read(buffer, buffer_u16);

    for (var i = 0; i < n_se; i++) {
        var se = new DataAudio();
    
        serialize_load_generic(buffer, se, version);
    
        se.temp_name = string_replace_all(buffer_read(buffer, buffer_string), ":", "_");
        var length = buffer_read(buffer, buffer_u32);
        var fbuffer = buffer_create(length, buffer_fixed, 1);
        buffer_copy(buffer, buffer_tell(buffer), length, fbuffer, 0);
        buffer_seek(buffer, buffer_seek_relative, length);
        buffer_save_ext(fbuffer, se.temp_name, 0, buffer_get_size(fbuffer));
        buffer_delete(fbuffer);
    
        se.fmod_rate = buffer_read(buffer, buffer_u32);
    
        if (length == 0) {
            wtf("Audio file was not embedded properly, you probably want to re-load: " + string(se.GUID) + " [" + se.name + "]");
        } else {
            se.SetFMOD(PROJECT_PATH_ROOT + se.temp_name);
        }
    
        array_push(Game.audio.se, se);
    }


}
