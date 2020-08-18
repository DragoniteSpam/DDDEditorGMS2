/// @param UIButton
function uivc_terrain_export(argument0) {

	var button = argument0;

	var fn = get_save_filename_mesh();

	if (fn != "") {
	    switch (filename_ext(fn)) {
	        case ".d3d": case ".gmmod": terrain_save_d3d(fn) break;
	        case ".obj": terrain_save_obj(fn); break;
	    }
	}


}
