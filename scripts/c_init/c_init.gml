function c_init() {
	/*
	Call this script once to initialize the collision system before using any of the other scripts. Game start is a good place to do this.
	*/
	var dll = "data\\collisions.dll";
	var calltype = dll_cdecl;

	global._c_world_create = external_define(dll, "c_world_create", calltype, ty_real, 0);
	global._c_world_destroy = external_define(dll, "c_world_destroy", calltype, ty_real, 0);
	global._c_world_exists = external_define(dll, "c_world_exists", calltype, ty_real, 0);
	global._c_world_add_object = external_define(dll, "c_world_add_object", calltype, ty_real, 1, ty_real);
	global._c_world_remove_object = external_define(dll, "c_world_remove_object", calltype, ty_real, 1, ty_real);
	global._c_world_get_count = external_define(dll, "c_world_get_count", calltype, ty_real, 0);
	global._c_object_create = external_define(dll, "c_object_create", calltype, ty_real, 3, ty_real, ty_real, ty_real);
	global._c_object_destroy = external_define(dll, "c_object_destroy", calltype, ty_real, 1, ty_real);
	global._c_object_exists = external_define(dll, "c_object_exists", calltype, ty_real, 1, ty_real);
	global._c_object_apply_transform = external_define(dll, "c_object_apply_transform", calltype, ty_real, 1, ty_real);
	global._c_object_set_shape = external_define(dll, "c_object_set_shape", calltype, ty_real, 2, ty_real, ty_real);
	global._c_object_set_mask = external_define(dll, "c_object_set_mask", calltype, ty_real, 3, ty_real, ty_real, ty_real);
	global._c_object_set_userid = external_define(dll, "c_object_set_userid", calltype, ty_real, 2, ty_real, ty_real);
	global._c_object_get_userid = external_define(dll, "c_object_get_userid", calltype, ty_real, 1, ty_real);
	global._c_shape_create = external_define(dll, "c_shape_create", calltype, ty_real, 0);
	global._c_shape_destroy = external_define(dll, "c_shape_destroy", calltype, ty_real, 1, ty_real);
	global._c_shape_exists = external_define(dll, "c_shape_exists", calltype, ty_real, 1, ty_real);
	global._c_shape_add_box = external_define(dll, "c_shape_add_box", calltype, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
	global._c_shape_add_sphere = external_define(dll, "c_shape_add_sphere", calltype, ty_real, 2, ty_real, ty_real);
	global._c_shape_add_capsule = external_define(dll, "c_shape_add_capsule", calltype, ty_real, 3, ty_real, ty_real, ty_real);
	global._c_shape_add_cylinder = external_define(dll, "c_shape_add_cylinder", calltype, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
	global._c_shape_add_cone = external_define(dll, "c_shape_add_cone", calltype, ty_real, 3, ty_real, ty_real, ty_real);
	global._c_shape_add_plane = external_define(dll, "c_shape_add_plane", calltype, ty_real, 5, ty_real, ty_real, ty_real, ty_real, ty_real);
	global._c_shape_begin_trimesh = external_define(dll, "c_shape_begin_trimesh", calltype, ty_real, 0);
	global._c_shape_load_trimesh = external_define(dll, "c_shape_load_trimesh", calltype, ty_real, 1, ty_string);
	global._c_shape_end_trimesh = external_define(dll, "c_shape_end_trimesh", calltype, ty_real, 1, ty_real);
	global._c_hit_x = external_define(dll, "c_hit_x", calltype, ty_real, 0);
	global._c_hit_y = external_define(dll, "c_hit_y", calltype, ty_real, 0);
	global._c_hit_z = external_define(dll, "c_hit_z", calltype, ty_real, 0);
	global._c_hit_nx = external_define(dll, "c_hit_nx", calltype, ty_real, 0);
	global._c_hit_ny = external_define(dll, "c_hit_ny", calltype, ty_real, 0);
	global._c_hit_nz = external_define(dll, "c_hit_nz", calltype, ty_real, 0);
	global._c_hit_fraction = external_define(dll, "c_hit_fraction", calltype, ty_real, 0);
	global._c_hit_object = external_define(dll, "c_hit_object", calltype, ty_real, 1, ty_real);
	global._c_transform_position = external_define(dll, "c_transform_position", calltype, ty_real, 3, ty_real, ty_real, ty_real);
	global._c_transform_rotation = external_define(dll, "c_transform_rotation", calltype, ty_real, 3, ty_real, ty_real, ty_real);
	global._c_transform_scaling = external_define(dll, "c_transform_scaling", calltype, ty_real, 3, ty_real, ty_real, ty_real);
	global._c_transform_identity = external_define(dll, "c_transform_identity", calltype, ty_real, 0);
	global._c_raycast_world = external_define(dll, "c_raycast_world", calltype, ty_real, 7, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
	global._c_raycast_object = external_define(dll, "c_raycast_object", calltype, ty_real, 7, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
	global._c_overlap_world = external_define(dll, "c_overlap_world", calltype, ty_real, 1, ty_real);
	global._c_overlap_world_position = external_define(dll, "c_overlap_world_position", calltype, ty_real, 4, ty_real, ty_real, ty_real, ty_real);
	global._c_overlap_object = external_define(dll, "c_overlap_object", calltype, ty_real, 2, ty_real, ty_real);
	global._c_sweep_world = external_define(dll, "c_sweep_world", calltype, ty_real, 8, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);
	global._c_shape_add_triangle = external_define(dll, "c_shape_add_triangle", calltype, ty_real, 9, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real, ty_real);


}
