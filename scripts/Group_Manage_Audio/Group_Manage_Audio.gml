function audio_add(filename, prefix, loop_mode) {
    var name = filename_name(filename);
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    
    var data = instance_create_depth(0, 0, 0, DataAudio);
    data.name = name;
    data.fmod = FMODGMS_Snd_LoadStream(filename);
    data.fmod_type = FMODGMS_Snd_Get_Type(data.fmod);
    FMODGMS_Snd_Set_LoopMode(data.fmod, loop_mode, -1);
    data.loop_start = 0;
    data.loop_end = FMODGMS_Snd_Get_Length(data.fmod);
    FMODGMS_Snd_Set_LoopPoints(data.fmod, 0, data.loop_end);
    
    data.temp_name = PATH_AUDIO + string(data.GUID) + filename_ext(filename);
    file_copy(filename, data.temp_name);
    
    internal_name_generate(data, prefix + internal_name);
    
    return data;
}

function audio_set_sample_rate(audio, rate) {
    audio.fmod_rate = rate;
    if (Stuff.fmod_sound == audio.fmod) {
        FMODGMS_Chan_Set_Frequency(Stuff.fmod_channel, rate);
    }
}