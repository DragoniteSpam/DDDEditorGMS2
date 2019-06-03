/// @description c_shape_add_cone(shape, radius, height)
/// @param shape
/// @param radius
/// @param height
/*
Adds a z-up facing cone to a shape, centered at (0,0,0)
Note: The shape will be added with the currently defined transformation.
*/
return external_call(global._c_shape_add_cone, argument0, argument1, argument2);
