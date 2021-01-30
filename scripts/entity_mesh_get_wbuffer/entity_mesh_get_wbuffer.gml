function entity_mesh_get_wbuffer(entity) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh = guid_get(entity.mesh);
    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].wbuffer : undefined;
}

function entity_mesh_get_reflect_wbuffer(entity) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh = guid_get(entity.mesh);
    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].reflect_wbuffer : undefined;
}