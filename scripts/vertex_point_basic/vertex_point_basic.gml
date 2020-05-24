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

vertex_position_3d(buffer, xx, yy, zz);
vertex_normal(buffer, nx, ny, nz);
vertex_texcoord(buffer, xtex, ytex);
vertex_colour(buffer, color, alpha);