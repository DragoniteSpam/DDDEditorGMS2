/// @param vbuff
/// @param x
/// @param y
/// @param z
/// @param color
/// @param alpha
function vertex_point_line(argument0, argument1, argument2, argument3, argument4, argument5) {

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

	vertex_position_3d(buffer, xx, yy, zz);
	vertex_normal(buffer, nx, ny, nz);
	vertex_texcoord(buffer, xtex, ytex);
	vertex_colour(buffer, color, alpha);
	// todo this - extra 32 bits for whatever you want
	vertex_colour(buffer, 0x000000, 1);


}
