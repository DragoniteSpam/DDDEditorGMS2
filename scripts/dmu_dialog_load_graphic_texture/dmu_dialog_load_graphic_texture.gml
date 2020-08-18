/// @param UIButton
function dmu_dialog_load_graphic_texture(argument0) {

	var button = argument0;

	var fn = get_open_filename_image();

	if (file_exists(fn)) {
	    tileset_create(fn);
	}


}
