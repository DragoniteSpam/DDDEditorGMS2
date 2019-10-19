var path = get_open_filename_ext("Audio files (*.ogg, *.mid)|*.ogg;*.mid", "", Stuff.setting_location_audio, "Select an audio file");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_audio = dir;
    setting_save_string("location", "audio", dir);
}

return path;