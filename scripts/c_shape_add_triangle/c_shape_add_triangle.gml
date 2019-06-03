/// @description c_shape_add_triangle(x1, y1, z1, x2, y2, z2, x3, y3, z3)
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3
/*
Adds a triangle to a trimesh. Make sure you call c_shape_begin_trimesh() before adding triangles.
*/
return external_call(global._c_shape_add_triangle, argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8);
