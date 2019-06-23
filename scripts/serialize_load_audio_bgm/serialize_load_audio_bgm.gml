/// @param buffer
/// @param version

var version = argument1;

ds_list_clear_instances(Stuff.all_bgm);
var n_bgm = buffer_read(argument0, buffer_u16);

for (var i = 0; i < n_bgm; i++) {
    var bgm = instantiate(DataAudio);
    
    serialize_load_generic(argument0, bgm, version);
    
    bgm.temp_name = buffer_read(argument0, buffer_string);
    bgm.loop_start = buffer_read(argument0, buffer_f32);
    bgm.loop_end = buffer_read(argument0, buffer_f32);
    
    var length = buffer_read(argument0, buffer_u32);
    var fbuffer = buffer_create(length, buffer_fixed, 1);
    buffer_copy(argument0, buffer_tell(argument0), length, fbuffer, 0);
    buffer_seek(argument0, buffer_seek_relative, length);
    buffer_save(fbuffer, bgm.temp_name);
    buffer_delete(fbuffer);
    
    if (length == 0) {
        debug("Audio file was not embedded properly, you probably want to re-load: " + string(bgm.GUID) + " [" + bgm.name + "]");
    } else {
        bgm.fmod = FMODGMS_Snd_LoadStream(environment_get_variable("localappdata") + "\\DDDEditor2\\" + bgm.temp_name);
        FMODGMS_Snd_Set_LoopMode(bgm.fmod, FMODGMS_LOOPMODE_NORMAL, -1);
        FMODGMS_Snd_Set_LoopPoints(bgm.fmod, bgm.loop_start * AUDIO_BASE_FREQUENCY, bgm.loop_end * AUDIO_BASE_FREQUENCY);
    }
    
    ds_list_add(Stuff.all_bgm, bgm);
}