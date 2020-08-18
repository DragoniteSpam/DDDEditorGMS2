/// @param shape
/// @param radius
/// @param height
function c_shape_add_capsule(argument0, argument1, argument2) {
	/*
	Adds a z-up facing capsule to a shape, centered at (0,0,0)
	Note: The shape will be added with the currently defined transformation.
	*/
	return external_call(global._c_shape_add_capsule, argument0, argument1, argument2);


}
