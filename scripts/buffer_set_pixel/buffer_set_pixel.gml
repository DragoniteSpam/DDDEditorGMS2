/// @param surface
/// @param buffer
/// @param x
/// @param y
/// @param color
function buffer_set_pixel(argument0, argument1, argument2, argument3, argument4) {

	var surface = argument0;
	var buffer = argument1;
	var xx = floor(argument2);
	var yy = floor(argument3);
	var color = argument4;
	var sw = surface_get_width(surface);
	var sh = surface_get_height(surface);
	var offset = (yy * sw + xx) * 4;

	buffer_poke(buffer, offset, buffer_u32, 0x000000ff | (color << 8));


}
