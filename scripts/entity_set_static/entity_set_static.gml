/// @param Entity
/// @param static?

var entity = argument0;
var static = argument1;

// SMF meshes are simply not allowed to be marked as static, or anything like that
if (instanceof(entity, EntityMesh) && guid_get(entity.mesh).type == MeshTypes.SMF) {
    return false;
}

var state = entity.static;
entity.static = static;

if (state != static) {
    Stuff.map.active_map.contents.population_static = Stuff.map.active_map.contents.population_static + static ? 1 : -1;
}