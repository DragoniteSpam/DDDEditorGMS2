/// @param shape
/// @param x_half_size
/// @param y_half_size
/// @param z_half_size
/*
Adds a box to a shape, centered at (0,0,0).
Note: The shape will be added with the currently defined transformation.
*/
return external_call(global._c_shape_add_box, argument0, argument1, argument2, argument3);