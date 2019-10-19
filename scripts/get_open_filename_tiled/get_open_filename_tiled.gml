var path = get_open_filename_ext("Tiled JSON files (*.json)|*.json", "", Stuff.setting_location_tiled, "Select a Tiled file");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_tiled = dir;
    setting_save_string("location", "tiled", dir);
}

return path;