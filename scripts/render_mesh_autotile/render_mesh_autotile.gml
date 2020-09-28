/// @param EntityMeshAutotile
function render_mesh_autotile(argument0) {

    var terrain = argument0;
    var mapping = global.at_map[? terrain.terrain_id];

    switch (terrain.terrain_type) {
        case ATTerrainTypes.TOP: var vbuffer = Stuff.map.active_map.contents.mesh_autotiles_top[mapping]; break;
        case ATTerrainTypes.VERTICAL: var vbuffer = Stuff.map.active_map.contents.mesh_autotiles_vertical[mapping]; break;
        case ATTerrainTypes.BASE: var vbuffer = Stuff.map.active_map.contents.mesh_autotiles_base[mapping]; break;
        case ATTerrainTypes.SLOPE: var vbuffer = Stuff.map.active_map.contents.mesh_autotiles_slope[mapping]; break;
        default: var vbuffer = noone; break;
    }

    transform_set(terrain.xx * TILE_WIDTH, terrain.yy * TILE_HEIGHT, terrain.zz * TILE_DEPTH, 0, 0, 0, 1, 1, 1);

    if (vbuffer && Stuff.setting_view_entities) {
        var tex = Stuff.setting_view_texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
        vertex_submit(vbuffer, pr_trianglelist, tex);
    }

    transform_reset();


}
