function render_mesh_autotile(mesh_autotile) {
    var mapping = global.at_map[? mesh_autotile.terrain_id];
    
    var at = guid_get(mesh_autotile.autotile_id);
    var vbuffer = at ? at.layers[mesh_autotile.terrain_type].tiles[mapping].vbuffer : Stuff.graphics.missing_autotile;
    var wbuffer = at ? at.layers[mesh_autotile.terrain_type].tiles[mapping].wbuffer : Stuff.graphics.missing_autotile_wire;
    if (!vbuffer) vbuffer = Stuff.graphics.missing_autotile;
    if (!wbuffer) wbuffer = Stuff.graphics.missing_autotile_wire;
    
    transform_set(mesh_autotile.xx * TILE_WIDTH, mesh_autotile.yy * TILE_HEIGHT, mesh_autotile.zz * TILE_DEPTH, 0, 0, 0, 1, 1, 1);
    
    if (Settings.view.entities) {
        var tex = Settings.view.texture ? sprite_get_texture(get_active_tileset().picture, 0) : sprite_get_texture(b_tileset_textureless, 0);
        vertex_submit(vbuffer, pr_trianglelist, tex);
    }
    
    if (Settings.view.wireframe) {
        vertex_submit(wbuffer, pr_linelist, -1);
    }
    
    transform_reset();
}