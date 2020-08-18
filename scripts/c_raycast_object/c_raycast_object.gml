/// @param object
/// @param xfrom
/// @param yfrom
/// @param zfrom
/// @param xto
/// @param yto
/// @param zto
/// @param mask
function c_raycast_object(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
	/*
	Casts a ray from (xfrom,yfrom,zfrom) to (xto,yto,zto), against the specified object.
	Returns true if the ray hit, and false if it did not.
	Use the c_hit_* functions to get more information about the hit.
	*/
	return external_call(global._c_raycast_object, argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7);


}
