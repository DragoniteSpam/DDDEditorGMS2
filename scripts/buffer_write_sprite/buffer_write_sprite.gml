/// @param buffer
/// @param sprite
function buffer_write_sprite(argument0, argument1) {

	var buffer = argument0;
	var sprite = argument1;

	var surface = sprite_to_surface(sprite, 0);
	var sw = surface_get_width(surface);
	var sh = surface_get_height(surface);
	var slength = sw * sh * 4;

	var sbuffer = buffer_create(slength, buffer_fixed, 1);
	var size = buffer_get_size(sbuffer);
	buffer_get_surface(sbuffer, surface, buffer_surface_copy, 0, 0);
	buffer_write(buffer, buffer_u16, sw);
	buffer_write(buffer, buffer_u16, sh);

	buffer_write_buffer(buffer, sbuffer);

	surface_free(surface);
	buffer_delete(sbuffer);


}
