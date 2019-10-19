/// @param [name]

var name = (argument_count > 0) ? argument[0] : "";

var path = get_save_filename_ext("drago's old file format (*.vrax)|*.vrax", name, Stuff.setting_location_mesh, "Select an vrax file");
var dir = filename_dir(path);

if (string_length(dir) > 0) {
    Stuff.setting_location_mesh = dir;
    setting_save_string("location", "mesh", dir);
}

return path;