/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

var path = get_save_filename_ext("Terrain files (*.ddd_terra)|*.ddd_terra", name, Stuff.setting_location_terrain, "Select a terrain file");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_terrain = dir;
    setting_set("Location", "terrain", dir);
}

return path;