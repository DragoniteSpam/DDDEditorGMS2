var path = get_open_filename_ext("Tiled JSON files (*.json)|*.json", "", Stuff.setting_location_tiled, "Select a Tiled file");

// @gml update try-catch
if (file_exists(path)) {
    var dir = filename_dir(path);

    if (string_length(dir) > 0) {
        Stuff.setting_location_tiled = dir;
        setting_set("Location", "tiled", dir);
    }
}

return path;