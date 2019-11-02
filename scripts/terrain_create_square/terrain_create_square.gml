/// @param buffer
/// @param x
/// @param y
/// @param z
/// @param size
/// @param tx
/// @param ty
/// @param tsize
/// @param texel

var buffer = argument0;
var xx = argument1;
var yy = argument2;
var zz = argument3;
var size = argument4;
var tx = argument5;
var ty = argument6;
var tsize = argument7;
var texel = argument8;

// (0, 0)
vertex_position_3d(buffer, xx, yy, zz);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + texel, ty + texel);
vertex_colour(buffer, c_white, 1);
// (1, 0)
vertex_position_3d(buffer, xx + size, yy, zz);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + tsize - texel, ty + texel);
vertex_colour(buffer, c_white, 1);
// (1, 1)
vertex_position_3d(buffer, xx + size, yy + size, zz);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
vertex_colour(buffer, c_white, 1);
// (1, 1)
vertex_position_3d(buffer, xx + size, yy + size, zz);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
vertex_colour(buffer, c_white, 1);
// (0, 1)
vertex_position_3d(buffer, xx, yy + size, zz);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + texel, ty + tsize - texel);
vertex_colour(buffer, c_white, 1);
// (0, 0)
vertex_position_3d(buffer, xx, yy, zz);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + texel, ty + texel);
vertex_colour(buffer, c_white, 1);