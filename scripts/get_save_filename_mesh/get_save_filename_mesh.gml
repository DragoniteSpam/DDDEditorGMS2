/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

var path = get_save_filename_ext("Any valid mesh|*.d3d;*.gmmod;*.obj;*.vbuff|Game Maker model files|*.d3d;*.gmmod|Object files|*.obj|Vertex buffers|*.vbuff", name, Stuff.setting_location_mesh, "Select a mesh");

// @gml update try-catch
if (path != "") {
    var dir = filename_dir(path);

    if (string_length(dir) > 0) {
        Stuff.setting_location_mesh = dir;
        setting_set("Location", "mesh", dir);
    }
}

return path;