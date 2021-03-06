/// @param entity
function entity_mesh_get_vbuffer(argument0) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier

    var entity = argument0;
    var mesh = guid_get(entity.mesh);

    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].vbuffer : noone;


}
