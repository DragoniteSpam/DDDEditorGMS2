/// @param xa
/// @param ya
/// @param za
/// @param angle
function c_transform_rotation_axis(argument0, argument1, argument2, argument3) {
	/*
	Sets the rotation of the transformation as an angle around an axis.
	Note: Angle is in radians.
	*/
	return external_call(global._c_transform_rotation_axis, argument0, argument1, argument2, argument3);


}
