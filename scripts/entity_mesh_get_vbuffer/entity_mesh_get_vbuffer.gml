function entity_mesh_get_vbuffer(entity) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh = guid_get(entity.mesh);
    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].vbuffer : undefined;
}

function entity_mesh_get_reflect_vbuffer(entity) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh = guid_get(entity.mesh);
    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].reflect_vbuffer : undefined;
}

function entity_mesh_get_texture(entity) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier
    var mesh = guid_get(entity.mesh);
    var def_texture = Settings.view.texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
    return (mesh && guid_get(mesh.tex_base)) ? sprite_get_texture(guid_get(mesh.tex_base).picture, 0) : def_texture;
}