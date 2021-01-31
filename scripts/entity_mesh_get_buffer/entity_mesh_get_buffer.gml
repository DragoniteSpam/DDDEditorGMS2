function entity_mesh_get_buffer(entity) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh = guid_get(entity.mesh);
    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].buffer : undefined;
}

function entity_mesh_get_reflect_buffer(entity) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh = guid_get(entity.mesh);
    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].reflect_buffer : undefined;
}