/// @param object
function c_world_remove_object(argument0) {
	/*
	Removes a collision object from the world. Does not destroy the object, it only removes it from the world.
	The object will no longer participate in world collision checks.
	*/
	return external_call(global._c_world_remove_object, argument0);


}
