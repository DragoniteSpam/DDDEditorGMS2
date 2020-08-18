/// @param object
function c_object_apply_transform(argument0) {
	/*
	Sets the transformation of the collision object to the currently defined transform.
	Note: Scaling has no effect on collision objects, it only works on shapes.
	*/
	return external_call(global._c_object_apply_transform, argument0);


}
