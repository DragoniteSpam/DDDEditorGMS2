/// @param buffer
/// @param version

var buffer = argument0;
var version = argument1;

if (version >= DataVersions.DATA_CHUNK_ADDRESSES) {
    var addr_next = buffer_read(buffer, buffer_u64);
}

ds_list_clear_instances(Stuff.all_bgm);

var n_bgm = buffer_read(buffer, buffer_u16);

for (var i = 0; i < n_bgm; i++) {
    var bgm = instance_create_depth(0, 0, 0, DataAudio);
    
    serialize_load_generic(buffer, bgm, version);
    
    bgm.temp_name = buffer_read(buffer, buffer_string);
    bgm.loop_start = buffer_read(buffer, buffer_f32);
    bgm.loop_end = buffer_read(buffer, buffer_f32);
    
    var length = buffer_read(buffer, buffer_u32);
    var fbuffer = buffer_create(length, buffer_fixed, 1);
    buffer_copy(buffer, buffer_tell(buffer), length, fbuffer, 0);
    buffer_seek(buffer, buffer_seek_relative, length);
    buffer_save(fbuffer, bgm.temp_name);
    buffer_delete(fbuffer);
    
    if (version >= DataVersions.FMOD_SAMPLE_RATE) {
        bgm.fmod_rate = buffer_read(buffer, buffer_u32);
    }
    
    if (length == 0) {
        debug("Audio file was not embedded properly, you probably want to re-load: " + string(bgm.GUID) + " [" + bgm.name + "]");
    } else {
        bgm.fmod = FMODGMS_Snd_LoadStream(environment_get_variable("localappdata") + "\\DDDEditor2\\" + bgm.temp_name);
        FMODGMS_Snd_Set_LoopMode(bgm.fmod, FMODGMS_LOOPMODE_NORMAL, -1);
        FMODGMS_Snd_Set_LoopPoints(bgm.fmod, bgm.loop_start * bgm.fmod_rate, bgm.loop_end * bgm.fmod_rate);
    }
    
    ds_list_add(Stuff.all_bgm, bgm);
}