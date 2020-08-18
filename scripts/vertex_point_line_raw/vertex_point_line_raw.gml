/// @param buffer
/// @param x
/// @param y
/// @param z
/// @param color
/// @param alpha
function vertex_point_line_raw(argument0, argument1, argument2, argument3, argument4, argument5) {

	var buffer = argument0;
	var xx = argument1;
	var yy = argument2;
	var zz = argument3;
	var nx = 0;
	var ny = 0;
	var nz = 1;
	var xtex = 0;
	var ytex = 0;
	var color = argument4;
	var alpha = argument5;

	buffer_write(buffer, buffer_f32, xx);
	buffer_write(buffer, buffer_f32, yy);
	buffer_write(buffer, buffer_f32, zz);
	buffer_write(buffer, buffer_f32, nx);
	buffer_write(buffer, buffer_f32, ny);
	buffer_write(buffer, buffer_f32, nz);
	buffer_write(buffer, buffer_f32, xtex);
	buffer_write(buffer, buffer_f32, ytex);
	buffer_write(buffer, buffer_u32, (floor(alpha * 255) << 24) | colour_reverse(color));
	buffer_write(buffer, buffer_u32, 0x00000000);


}
