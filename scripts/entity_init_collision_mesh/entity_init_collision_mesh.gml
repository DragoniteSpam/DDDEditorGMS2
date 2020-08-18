/// @param EntityMesh
function entity_init_collision_mesh(argument0) {

	var mesh = argument0;
	var mesh_data = guid_get(mesh.mesh);

	if (mesh_data.cshape) {
	    mesh.cobject = c_object_create_cached(mesh_data.cshape, CollisionMasks.MAIN, CollisionMasks.MAIN);
	}


}
