/// @param object
/// @param shape
function c_object_set_shape(argument0, argument1) {
	/*
	Sets the shape of the collision object.
	*/
	return external_call(global._c_object_set_shape, argument0, argument1);


}
