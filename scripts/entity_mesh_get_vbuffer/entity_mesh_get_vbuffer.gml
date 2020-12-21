/// @param entity
function entity_mesh_get_vbuffer(argument0) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier

    var entity = argument0;
    var mesh = guid_get(entity.mesh);

    return mesh ? mesh.submeshes[| proto_guid_get(mesh, entity.mesh_submesh)].vbuffer : noone;


}

/// @param entity
function entity_mesh_get_texture(argument0) {
    // the lookup for an entity's exact mesh is now somewhat complicated, so this
    // script is here to make yoru life easier

    var entity = argument0;
    var mesh = guid_get(entity.mesh);
    var ts = get_active_tileset()
    var def_texture = Settings.view.texture ? sprite_get_texture(ts.picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
    return (mesh && guid_get(mesh.tex_base)) ? sprite_get_texture(guid_get(mesh.tex_base).picture, 0) : def_texture;


}
