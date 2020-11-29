function render_tile(tile) {
    var TEXEL = 1 / TEXTURE_SIZE;
    
    var xx = tile.xx * TILE_WIDTH;
    var yy = tile.yy * TILE_HEIGHT;
    var zz = tile.zz * TILE_DEPTH;
    
    var ts = get_active_tileset();
    
    if (Stuff.settings.view.entities) {
        var tex = sprite_get_texture(Stuff.settings.view.texture ? ts.picture : b_tileset_textureless, 0);
        transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
        vertex_submit(tile.vbuffer, pr_trianglelist, tex);
        transform_reset();
    }
    
    if (Stuff.settings.view.wireframe) {
        transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
        vertex_submit(tile.wbuffer, pr_linelist, -1);
        transform_reset();
    }
}