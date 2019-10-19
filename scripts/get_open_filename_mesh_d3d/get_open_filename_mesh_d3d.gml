var path = get_open_filename_ext("Game Maker model files (*.d3d;*.gmmod)|*.d3d;*.gmmod", "", Stuff.setting_location_mesh, "Select a mesh");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_mesh = dir;
    setting_save_string("location", "mesh", dir);
}

return path;