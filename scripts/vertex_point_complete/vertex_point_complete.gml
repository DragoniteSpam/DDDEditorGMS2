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

var buffer = argument[0];
var xx = argument[1];
var yy = argument[2];
var zz = argument[3];
var nx = argument[4];
var ny = argument[5];
var nz = argument[6];
var xtex = argument[7];
var ytex = argument[8];
var color = argument[9];
var alpha = argument[10];
var atid = (argument_count > 11) ? argument[11] : 0;

vertex_position_3d(buffer, xx, yy, zz);
vertex_normal(buffer, nx, ny, nz);
vertex_texcoord(buffer, xtex, ytex);
vertex_colour(buffer, color, alpha);

// todo this - extra 32 bits for whatever you want
vertex_colour(buffer, 0, 0);