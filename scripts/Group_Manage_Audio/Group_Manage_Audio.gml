function audio_add_bgm(filename, name) {
    if (name == undefined) name = filename_name(filename);
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    
    var data = instance_create_depth(0, 0, 0, DataAudio);
    data.name = name;
    data.fmod = FMODGMS_Snd_LoadStream(filename);
    data.fmod_type = FMODGMS_Snd_Get_Type(data.fmod);
    FMODGMS_Snd_Set_LoopMode(data.fmod, FMODGMS_LOOPMODE_NORMAL, -1);
    data.loop_start = 0;
    data.loop_end = FMODGMS_Snd_Get_Length(data.fmod);
    FMODGMS_Snd_Set_LoopPoints(data.fmod, 0, data.loop_end);
    
    data.temp_name = PATH_AUDIO + string(data.GUID) + filename_ext(filename);
    file_copy(filename, data.temp_name);
    
    internal_name_generate(data, PREFIX_AUDIO_BGM + internal_name);
    ds_list_add(Stuff.all_bgm, data);
    
    return data;
}

function audio_add_se(filename, name) {
    if (name == undefined) name = filename_name(filename);
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    
    var data = instance_create_depth(0, 0, 0, DataAudio);
    data.name = name;
    data.fmod = FMODGMS_Snd_LoadStream(filename);
    data.fmod_type = FMODGMS_Snd_Get_Type(data.fmod);
    
    data.temp_name = PATH_AUDIO + string(data.GUID) + filename_ext(filename);
    file_copy(filename, data.temp_name);
    
    internal_name_generate(data, PREFIX_AUDIO_SE + internal_name);
    ds_list_add(Stuff.all_se, data);
    
    return data;
}

function audio_remove_bgm(guid) {
    var data = guid_get(guid);
    FMODGMS_Snd_Unload(data.fmod);
    ds_list_delete(Stuff.all_bgm, ds_list_find_index(Stuff.all_bgm, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function audio_remove_se(guid) {
    var data = guid_get(guid);
    FMODGMS_Snd_Unload(data.fmod);
    ds_list_delete(Stuff.all_se, ds_list_find_index(Stuff.all_se, data));
    instance_activate_object(data);
    instance_destroy(data);
}

function audio_set_sample_rate(audio, rate) {
    audio.fmod_rate = rate;
    if (Stuff.fmod_sound == audio.fmod) {
        FMODGMS_Chan_Set_Frequency(Stuff.fmod_channel, rate);
    }
}