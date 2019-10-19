var path = get_open_filename_ext("DDD game files (" + EXPORT_EXTENSION_DATA + ", " + EXPORT_EXTENSION_MAP + ", " + EXPORT_EXTENSION_ASSETS + ")|*" + EXPORT_EXTENSION_DATA + ";*" + EXPORT_EXTENSION_MAP + ";*" + EXPORT_EXTENSION_ASSETS, "", Stuff.setting_location_ddd, "Select a game data file");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_ddd = dir;
    setting_save_string("location", "ddd", dir);
}

return path;