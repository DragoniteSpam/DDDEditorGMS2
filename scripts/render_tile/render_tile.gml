function render_tile(tile) {
    var TEXEL = 1 / TEXTURE_SIZE;
    
    var xx = tile.xx * TILE_WIDTH;
    var yy = tile.yy * TILE_HEIGHT;
    var zz = tile.zz * TILE_DEPTH;
    
    var ts = get_active_tileset();
    
    if (Settings.view.entities) {
        var tex = sprite_get_texture(Settings.view.texture ? ts.picture : b_tileset_textureless, 0);
        transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
        vertex_submit(tile.vbuffer, pr_trianglelist, tex);
        matrix_set(matrix_world, matrix_build_identity());
    }
    
    if (Settings.view.wireframe) {
        transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
        vertex_submit(tile.wbuffer, pr_linelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    }
}