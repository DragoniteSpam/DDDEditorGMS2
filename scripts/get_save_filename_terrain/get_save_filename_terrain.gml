/// @param [name]
function get_save_filename_terrain() {

    var name = (argument_count > 0) ? argument[0] : "";

    var path = get_save_filename_ext("Terrain files (*.dddt)|*.dddt", name, Stuff.setting_location_terrain, "Select a terrain file");

    // @gml update try-catch
    if (path != "") {
        var dir = filename_dir(path);

        if (string_length(dir) > 0) {
            Stuff.setting_location_terrain = dir;
            setting_set("Location", "terrain", dir);
        }
    }

    return path;


}
