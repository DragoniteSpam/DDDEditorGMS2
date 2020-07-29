/// @param EntityMesh

var entity = argument0;
var mesh = guid_get(entity.mesh);

transform_set(0, 0, 0, entity.rot_xx, entity.rot_yy, entity.rot_zz, 1, 1, 1);
transform_add(0, 0, 0, 0, 0, 0, entity.scale_xx, entity.scale_yy, entity.scale_zz);
transform_add((entity.xx + entity.off_xx) * TILE_WIDTH, (entity.yy + entity.off_yy) * TILE_HEIGHT, (entity.zz + entity.off_zz) * TILE_DEPTH, 0, 0, 0, 1, 1, 1);

var ts = get_active_tileset();

if (Stuff.setting_view_entities) {
    var tex = Stuff.setting_view_texture ? sprite_get_texture(ts.picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
    vertex_submit(entity_mesh_get_vbuffer(entity), pr_trianglelist, tex);
}

if (Stuff.setting_view_wireframe) {
    vertex_submit(entity_mesh_get_wbuffer(entity), pr_linelist, -1);
}

transform_reset();