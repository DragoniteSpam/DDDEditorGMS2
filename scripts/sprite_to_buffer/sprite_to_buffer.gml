/// @param sprite
/// @param subimg
function sprite_to_buffer() {
	// by yellowafterlife

	var sprite = argument[0];
	var frame = argument[1];
	var surface = sprite_to_surface(sprite, frame);
	var sw = sprite_get_width(sprite);
	var sh = sprite_get_height(sprite);
	var buffer = buffer_create(sw * sh * 4, buffer_fast, 1);
	buffer_get_surface(buffer, surface, buffer_surface_copy, 0, 0);
	surface_free(surface);

	return buffer;


}
