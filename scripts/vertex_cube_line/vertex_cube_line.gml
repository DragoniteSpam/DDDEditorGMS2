/// @param vbuff
/// @param x
/// @param y
/// @param z
/// @param color
/// @param alpha
/// @param size
function vertex_cube_line(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {

	var buffer = argument0;
	var xx = argument1;
	var yy = argument2;
	var zz = argument3;
	var color = argument4;
	var alpha = argument5;
	var size = argument6;

	// one
	vertex_point_line(buffer, xx - size, yy - size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy - size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz - size, color, alpha);
	vertex_point_line(buffer, xx - size, yy + size, zz - size, color, alpha);
	vertex_point_line(buffer, xx - size, yy - size, zz - size, color, alpha);
	// two
	vertex_point_line(buffer, xx - size, yy - size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy - size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy - size, zz + size, color, alpha);
	// three
	vertex_point_line(buffer, xx - size, yy - size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy - size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy - size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy - size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy - size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy - size, zz - size, color, alpha);
	// four
	vertex_point_line(buffer, xx - size, yy + size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy + size, zz - size, color, alpha);
	// five
	vertex_point_line(buffer, xx - size, yy - size, zz - size, color, alpha);
	vertex_point_line(buffer, xx - size, yy + size, zz - size, color, alpha);
	vertex_point_line(buffer, xx - size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy - size, zz + size, color, alpha);
	vertex_point_line(buffer, xx - size, yy - size, zz - size, color, alpha);
	// six
	vertex_point_line(buffer, xx + size, yy - size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz - size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy + size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy - size, zz + size, color, alpha);
	vertex_point_line(buffer, xx + size, yy - size, zz - size, color, alpha);


}
