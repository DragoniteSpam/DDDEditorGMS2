/// @param [name]
function get_save_filename_gml() {

    var name = (argument_count > 0) ? argument[0] : "";

    var path = get_save_filename_ext("GML code files|*.gml", name, Stuff.setting_location_gml, "Save a code file");

    // @gml update try-catch
    if (path != "") {
        var dir = filename_dir(path);

        if (string_length(dir) > 0) {
            Stuff.setting_location_gml = dir;
            setting_set("Location", "gml", dir);
        }
    }

    return path;


}
