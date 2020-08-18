/// @param [name]
function get_save_filename_mesh_qma() {

	var name = (argument_count > 0) ? argument[0] : "";

	var path = get_save_filename_ext("quack model archive files (*.qma)|*.qma", name, Stuff.setting_location_mesh, "Select a file");

	// @gml update try-catch
	if (path != "") {
	    var dir = filename_dir(path);

	    if (string_length(dir) > 0) {
	        Stuff.setting_location_mesh = dir;
	        setting_set("Location", "mesh", dir);
	    }
	}

	return path;


}
