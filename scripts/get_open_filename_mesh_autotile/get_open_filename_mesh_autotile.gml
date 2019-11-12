var path = get_open_filename_ext("Mesh Autotile files (*.ddd_atm)|*.ddd_atm", "", Stuff.setting_location_mesh, "Select a mesh autotile collection");

// @todo gml update try-catch
if (file_exists(path)) {
    var dir = filename_dir(path);

    if (string_length(dir) > 0) {
        Stuff.setting_location_mesh = dir;
        setting_set("Location", "mesh", dir);
    }
}

return path;