function c_shape_begin_trimesh() {
	/*
	Creates a trimesh that you can add triangles to. Call this before adding any triangles.
	Note: Trimeshes cannot collide with other trimeshes. Intended use is static level geometry.
	*/
	return external_call(global._c_shape_begin_trimesh);


}
