/// @param EntityMesh

var mesh = argument0;

return false;

var mesh_data = guid_get(mesh.mesh);

transform_set(0, 0, 0, mesh.rot_xx, mesh.rot_yy, mesh.rot_zz, 1, 1, 1);
transform_add(0, 0, 0, 0, 0, 0, mesh.scale_xx, mesh.scale_yy, mesh.scale_zz);
transform_add((mesh.xx + mesh.off_xx) * TILE_WIDTH, (mesh.yy + mesh.off_yy) * TILE_HEIGHT, (mesh.zz + mesh.off_zz) * TILE_DEPTH, 0, 0, 0, 1, 1, 1);

if (Stuff.setting_view_entities) {
    if (Stuff.setting_view_texture) {
        var tex = sprite_get_texture(get_active_tileset().master, 0);
    } else {
        var tex = sprite_get_texture(b_tileset_textureless, 0);
    }
    
    vertex_submit(mesh_data.vbuffer, pr_trianglelist, tex);
}

if (Stuff.setting_view_wireframe) {
    vertex_submit(mesh_data.wbuffer, pr_linelist, -1);
}

transform_reset();