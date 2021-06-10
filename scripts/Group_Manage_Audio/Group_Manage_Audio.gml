function audio_add(filename, prefix, loop_mode) {
    var name = filename_name(filename);
    var internal_name = string_lettersdigits(string_replace_all(name, filename_ext(filename), ""));
    
    var data = new DataAudio(name);
    data.SetFMOD(filename);
    data.SetFMODLoop(loop_mode);
    
    data.temp_name = PATH_AUDIO + string_replace_all(string(data.GUID), ":", "_") + filename_ext(filename);
    file_copy(filename, data.temp_name);
    
    internal_name_generate(data, prefix + internal_name);
    
    return data;
}