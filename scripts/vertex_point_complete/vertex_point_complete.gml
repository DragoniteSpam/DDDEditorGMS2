/// @param vbuff
/// @param x
/// @param y
/// @param z
/// @param nx
/// @param ny
/// @param nz
/// @param xtex
/// @param ytex
/// @param color
/// @param alpha
/// @param [id]
// Assume vbuff is a vertex buffer created using the correct format.

var buffer = argument0;
var xx = argument1;
var yy = argument2;
var zz = argument3;
var nx = argument4;
var ny = argument5;
var nz = argument6;
var xtex = argument7;
var ytex = argument8;
var color = argument9;
var alpha = argument10;
var atid = (argument_count > 11) ? argument[11] : 0;

vertex_position_3d(buffer, xx, yy, zz);
vertex_normal(buffer, nx, ny, nz);
vertex_texcoord(buffer, xtex, ytex);
vertex_colour(buffer, color, alpha);
// todo this - extra 32 bits for whatever you want
vertex_colour(buffer, 0x000000, 1);