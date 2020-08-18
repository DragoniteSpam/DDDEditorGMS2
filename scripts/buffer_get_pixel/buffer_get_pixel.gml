/// @param surface
/// @param buffer
/// @param x
/// @param y
function buffer_get_pixel(argument0, argument1, argument2, argument3) {

	var surface = argument0;
	var buffer = argument1;
	var xx = floor(argument2);
	var yy = floor(argument3);
	var sw = surface_get_width(surface);
	var sh = surface_get_height(surface);
	var offset = (yy * sw + xx) * 4;

	return buffer_peek(buffer, offset, buffer_u32) >> 8;


}
