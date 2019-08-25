/// @param filename
/*
Loads a trimesh from a GameMaker model file.
Only triangle lists are supported. Triangle fans/strips don't load properly and primitive shapes are ignored.
Returns 1 if successful, 0 for undefined trimesh, and -1 for file system error.
*/

return external_call(global._c_shape_load_trimesh, argument0);