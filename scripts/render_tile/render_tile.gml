function render_tile(tile) {
    var xx = tile.xx * TILE_WIDTH;
    var yy = tile.yy * TILE_HEIGHT;
    var zz = tile.zz * TILE_DEPTH;
    
    var ts = MAP_ACTIVE_TILESET;
    
    if (Settings.view.entities) {
        var tex = sprite_get_texture(Settings.view.texture ? ts.picture : b_tileset_textureless, 0);
        transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
        vertex_submit(tile.vbuffer, pr_trianglelist, tex);
        matrix_set(matrix_world, matrix_build_identity());
    }
}