/// @param EntityMesh

var entity = argument0;
var mesh = guid_get(entity.mesh);

transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, 0, 0, 0, 1, 1, 1);

if (Camera.view_entities) {
    if (Camera.view_texture) {
        var tex = sprite_get_texture(get_active_tileset().master, 0);
    } else {
        var tex = sprite_get_texture(b_tileset_textureless, 0)
    }
    
    vertex_submit(mesh.vbuffer, pr_trianglelist, tex);
}

if (Camera.view_wireframe) {
    vertex_submit(mesh.wbuffer, pr_linelist, -1);
}

transform_reset();