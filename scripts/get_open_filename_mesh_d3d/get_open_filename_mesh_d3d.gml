var path = get_open_filename_ext("Game Maker model files (*.d3d;*.gmmod)|*.d3d;*.gmmod", "", Stuff.setting_location_mesh, "Select a mesh");

// @gml update try-catch
if (file_exists(path)) {
    var dir = filename_dir(path);

    if (string_length(dir) > 0) {
        Stuff.setting_location_mesh = dir;
        setting_set("Location", "mesh", dir);
    }
}

return path;