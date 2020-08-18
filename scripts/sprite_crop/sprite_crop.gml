/// @param sprite
/// @param [cutoff]
/// @param [max-w]
/// @param [max-h]
function sprite_crop() {

	var sprite = argument[0];
	var cutoff = (argument_count > 1) ? argument[1] : 0;
	var ww = (argument_count > 2) ? argument[2] : -1;
	var hh = (argument_count > 3) ? argument[3] : -1;

	var dimensions = sprite_get_cropped_dimensions(sprite, 0, cutoff);

	if (ww == -1) {
	    ww = dimensions[vec2.xx];
	} else {
	    ww = min(ww, dimensions[vec2.xx]);
	}
	if (hh == -1) {
	    hh = dimensions[vec2.yy];
	} else {
	    hh = min(hh, dimensions[vec2.yy]);
	}

	var surface = surface_create(ww, hh);
	surface_set_target(surface);
	draw_clear_alpha(c_black, 0);
	gpu_set_blendmode(bm_add);
	draw_sprite(sprite, 0, 0, 0);
	gpu_set_blendmode(bm_normal);
	var sprite = sprite_create_from_surface(surface, 0, 0, ww, hh, false, false, 0, 0);
	surface_reset_target();
	surface_free(surface);

	return sprite;


}
