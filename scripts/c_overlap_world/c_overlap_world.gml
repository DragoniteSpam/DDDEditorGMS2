/// @param object
/*
Checks if the object overlaps any other object in the world. The object does not need to be in the world.
Returns the number of objects that are overlapping this object. Use c_hit_object(n) to get those objects.
*/
return external_call(global._c_overlap_world, argument0);