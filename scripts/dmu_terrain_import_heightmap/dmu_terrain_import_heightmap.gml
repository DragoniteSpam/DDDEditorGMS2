/// @param UIButton
function dmu_terrain_import_heightmap(argument0) {

	var button = argument0;

	var fn = get_open_filename_image();

	if (fn != "") {
	    terrain_import_heightmap(button, fn);
	    script_execute(button.root.commit, button.root);
	}


}
