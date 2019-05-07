/// @description c_shape_add_sphere(shape, radius)
/// @param shape
/// @param  radius
/*
Adds a sphere to a shape, centered at (0,0,0)
This shape is very efficient, but it can't have a non-uniform scale.
Note: The shape will be added with the currently defined transformation.
*/
return external_call(global._c_shape_add_sphere, argument0, argument1);
