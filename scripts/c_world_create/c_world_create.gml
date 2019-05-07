/// @description c_world_create()
/*
Creates the collision world. There can only be one world at a time. Returns true if successful.
The collision world lets you perform collision checks against multiple objects at once.
You must create the collision world before you call perform any collision checks, even if you are only performing checks on individual objects.
*/
return external_call(global._c_world_create);
