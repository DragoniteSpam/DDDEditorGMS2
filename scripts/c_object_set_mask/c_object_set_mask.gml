/// @param object
/// @param group
/// @param mask
function c_object_set_mask(argument0, argument1, argument2) {
	/*
	Sets the collision mask of the object.
	*/
	return external_call(global._c_object_set_mask, argument0, argument1, argument2);


}
