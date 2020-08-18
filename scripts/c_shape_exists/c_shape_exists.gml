/// @param shape
function c_shape_exists(argument0) {
	/*
	Returns true if the shape exists, and false otherwise.
	*/
	return external_call(global._c_shape_exists, argument0);


}
