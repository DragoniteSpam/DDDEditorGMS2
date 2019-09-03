/// @param vbuff
/// @param x
/// @param y
/// @param z
/// @param color
/// @param alpha

vertex_position_3d(argument0, argument1, argument2, argument3);
vertex_normal(argument0, 0, 0, 1);
vertex_texcoord(argument0, 0, 0);
vertex_colour(argument0, argument4, argument5);
// todo this - extra 32 bits for whatever you want
vertex_colour(argument0, 0x000000, 1);