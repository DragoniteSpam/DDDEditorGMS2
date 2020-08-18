/// @param Entity
/// @param static?
function entity_set_static(argument0) {

	var entity = argument0;
	var static = argument1;

	// SMF meshes are simply not allowed to be marked as static, or anything like that
	if (instanceof_classic(entity, EntityMesh) && guid_get(entity.mesh).type == MeshTypes.SMF) {
	    return false;
	}

	var state = entity.static;
	entity.static = static;

	if (state != static) {
	    Stuff.map.active_map.contents.population_static = Stuff.map.active_map.contents.population_static + static ? 1 : -1;
	}


}
