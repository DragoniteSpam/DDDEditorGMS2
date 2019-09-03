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

var atid = (argument_count > 11) ? argument[11] : 0;

vertex_position_3d(argument[0], argument[1], argument[2], argument[3]);
vertex_normal(argument[0], argument[4], argument[5], argument[6]);
vertex_texcoord(argument[0], argument[7], argument[8]);
vertex_colour(argument[0], argument[9], argument[10]);
// todo this - extra 32 bits for whatever you want
vertex_colour(argument[0], 0x000000, 1);