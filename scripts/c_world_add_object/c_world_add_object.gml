/// @param object
function c_world_add_object(argument0) {
	/*
	Adds a collision object to the world, so it will participate in world collision checks.
	*/
	return external_call(global._c_world_add_object, argument0);


}
