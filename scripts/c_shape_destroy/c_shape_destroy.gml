/// @description c_shape_destroy(shape)
/// @param shape
/*
Destroys the shape, freeing the memory used. Don't destroy a shape while there are objects using it.
*/
return external_call(global._c_shape_destroy, argument0);
