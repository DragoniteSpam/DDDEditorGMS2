/// @param EntityMeshAutotile

var terrain = argument0;
var mapping = Stuff.autotile_map[? terrain.terrain_id];
var vbuffer = Stuff.map.active_map.contents.mesh_autotiles[mapping];

transform_set(terrain.xx * TILE_WIDTH, terrain.yy * TILE_HEIGHT, terrain.zz * TILE_DEPTH, 0, 0, 0, 1, 1, 1);

if (Stuff.setting_view_entities) {
    if (Stuff.setting_view_texture) {
        var tex = sprite_get_texture(get_active_tileset().master, 0);
    } else {
        var tex = sprite_get_texture(b_tileset_textureless, 0);
    }
    
    vertex_submit(vbuffer, pr_trianglelist, tex);
}

transform_reset();