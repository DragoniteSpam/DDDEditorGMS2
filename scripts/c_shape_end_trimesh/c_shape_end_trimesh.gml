/// @param shape
function c_shape_end_trimesh(argument0) {
	/*
	Call this when done adding triangles to a trimesh. This function adds the trimesh to the shape.
	Note: The trimesh will be added with the currently defined transformation.
	Note: Trimeshes cannot collide with other trimeshes. Intended use is static level geometry.
	*/
	return external_call(global._c_shape_end_trimesh, argument0);


}
