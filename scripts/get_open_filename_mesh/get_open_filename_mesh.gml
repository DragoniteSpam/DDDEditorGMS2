var path = get_open_filename_ext("Any valid mesh file|*.d3d;*.gmmod;*.obj;*.vrax;*.smf|Game Maker model files|*.d3d;*.gmmod|Object files|*.obj|drago's old file format|*.vrax|SMF files (advanced)|*.smf", "", Stuff.setting_location_mesh, "Select a mesh autotile collection");

// @todo gml update try-catch
if (file_exists(path)) {
    var dir = filename_dir(path);

    if (string_length(dir) > 0) {
        Stuff.setting_location_mesh = dir;
        setting_set("Location", "mesh", dir);
    }
}

return path;