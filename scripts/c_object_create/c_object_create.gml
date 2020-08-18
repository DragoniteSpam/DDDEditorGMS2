/// @param shape
/// @param group
/// @param mask
function c_object_create(argument0, argument1, argument2) {
	/*
	Creates a collision object from a shape and returns the id.

	The "group" argument is an integer bitfield where each bit represents a group. This is the group that this object is in.
	The "mask" argument sets which groups this object can collide with.
	A bitwise AND operation is performed with the group of one object and the mask of another whenever there is a collision check.

	For a collision to occur between two objects, both objects' masks must include each other.
	*/

	return external_call(global._c_object_create, argument0, argument1, argument2);


}
