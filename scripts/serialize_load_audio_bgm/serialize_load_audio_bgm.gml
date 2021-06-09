/// @param buffer
/// @param version
function serialize_load_audio_bgm(argument0, argument1) {

    var buffer = argument0;
    var version = argument1;

    var addr_next = buffer_read(buffer, buffer_u64);

    var n_bgm = buffer_read(buffer, buffer_u16);

    for (var i = 0; i < n_bgm; i++) {
        var bgm = new DataAudio();
    
        serialize_load_generic(buffer, bgm, version);
    
        bgm.temp_name = string_replace_all(buffer_read(buffer, buffer_string), ":", "_");
        bgm.loop_start = buffer_read(buffer, buffer_f32);
        bgm.loop_end = buffer_read(buffer, buffer_f32);
    
        var length = buffer_read(buffer, buffer_u32);
        var fbuffer = buffer_create(length, buffer_fixed, 1);
        buffer_copy(buffer, buffer_tell(buffer), length, fbuffer, 0);
        buffer_seek(buffer, buffer_seek_relative, length);
        buffer_save_ext(fbuffer, bgm.temp_name, 0, buffer_get_size(fbuffer));
        buffer_delete(fbuffer);
    
        bgm.fmod_rate = buffer_read(buffer, buffer_u32);
    
        if (length == 0) {
            wtf("Audio file was not embedded properly, you probably want to re-load: " + string(bgm.GUID) + " [" + bgm.name + "]");
        } else {
            bgm.fmod = FMODGMS_Snd_LoadStream(environment_get_variable("localappdata") + "\\" + game_project_name + "\\" + bgm.temp_name);
            FMODGMS_Snd_Set_LoopMode(bgm.fmod, FMODGMS_LOOPMODE_NORMAL, -1);
            FMODGMS_Snd_Set_LoopPoints(bgm.fmod, bgm.loop_start, bgm.loop_end);
        }
    
        ds_list_add(Stuff.all_bgm, bgm);
    }


}
