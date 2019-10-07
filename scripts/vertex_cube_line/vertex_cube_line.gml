/// @param vbuff
/// @param x
/// @param y
/// @param z
/// @param color
/// @param alpha
/// @param size

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