/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

var path = get_save_filename_ext("DDD game data files|*" + EXPORT_EXTENSION_DATA, name, Stuff.setting_location_ddd, "Select a data file");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_ddd = dir;
    setting_save_string("location", "ddd", dir);
}

return path;