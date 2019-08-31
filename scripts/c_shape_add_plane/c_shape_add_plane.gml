/// @param shape
/// @param nx
/// @param ny
/// @param nz
/// @param distance
/*
Adds an infinite plane that is solid to infinity on one side. It is defined by a surface normal and the distance to the world origin.
*/
return external_call(global._c_shape_add_plane, argument0, argument1, argument2, argument3, argument4);