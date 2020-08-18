/// @param file
function terrain_create_texture_sprite(argument0) {

	var fn = argument0;

	var sprite = sprite_add(fn, 0, false, false, 0, 0);

	if (sprite) {
	    var surface = surface_create(4096, 4096);
	    surface_set_target(surface);
	    draw_clear_alpha(c_white, 1);
	    draw_sprite(sprite, 0, 0, 0);
	    surface_reset_target();
	    var output = sprite_create_from_surface(surface, 0, 0, 4096, 4096, false, false, 0, 0);
	    sprite_delete(sprite);
	    surface_free(surface);
    
	    return output;
	}

	return -1;


}
