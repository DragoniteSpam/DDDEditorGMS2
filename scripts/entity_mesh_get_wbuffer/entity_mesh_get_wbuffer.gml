/// @param entity
// the lookup for an entity's exact mesh is now somewhat complicated, so this
// script is here to make yoru life easier

var entity = argument0;
var mesh = guid_get(entity.mesh);

return mesh ? mesh.wbuffers[| proto_guid_get(mesh, entity.mesh_submesh)] : noone;