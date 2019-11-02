var path = get_open_filename_ext("Terrain files (*.ddd_terra)|*.ddd_terra", "", Stuff.setting_location_terrain, "terrain file");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_terrain = dir;
    setting_save_string("location", "terrain", dir);
}

return path;