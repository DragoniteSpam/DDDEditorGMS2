/// @param object1
/// @param object2
/*
Checks if two objects overlap each other. The objects do not need to be in the world.
Returns true if there is an overlap, and false if not.
*/
return external_call(global._c_overlap_object, argument0, argument1);