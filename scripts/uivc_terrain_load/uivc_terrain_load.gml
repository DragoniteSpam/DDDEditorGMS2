/// @param UIButton
function uivc_terrain_load(argument0) {

	var button = argument0;

	var fn = get_open_filename_terrain();

	if (fn != "") {
	    terrain_load(fn);
	}


}
