/// @param buffer
/// @param x
/// @param y
/// @param z
/// @param tx
/// @param ty
/// @param tsize
/// @param texel

var buffer = argument0;
var xx = argument1;
var yy = argument2;
var zz = argument3;
var tx = argument4;
var ty = argument5;
var tsize = argument6;
var texel = argument7;

// (0, 0)
vertex_position_3d(buffer, xx, yy, 0);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + texel, ty + texel);
vertex_colour(buffer, c_white, 1);
// (1, 0)
vertex_position_3d(buffer, xx + 1, yy, 0);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + tsize - texel, ty + texel);
vertex_colour(buffer, c_white, 1);
// (1, 1)
vertex_position_3d(buffer, xx + 1, yy + 1, 0);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
vertex_colour(buffer, c_white, 1);
// (1, 1)
vertex_position_3d(buffer, xx + 1, yy + 1, 0);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + tsize - texel, ty + tsize - texel);
vertex_colour(buffer, c_white, 1);
// (0, 1)
vertex_position_3d(buffer, xx, yy + 1, 0);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + texel, ty + tsize - texel);
vertex_colour(buffer, c_white, 1);
// (0, 0)
vertex_position_3d(buffer, xx, yy, 0);
vertex_normal(buffer, 0, 0, 1);
vertex_texcoord(buffer, tx + texel, ty + texel);
vertex_colour(buffer, c_white, 1);