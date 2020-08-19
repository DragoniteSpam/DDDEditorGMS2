/// @param UIButton
function uivc_terrain_export_texture(argument0) {

	var button = argument0;
	var terrain = Stuff.terrain;

	var fn = get_save_filename_image(terrain.texture_name);

	if (fn != "") {
	    sprite_save(terrain.texture, 0, fn, terrain.texture_width, terrain.texture_height);
	}


}
