/// @param EntityTile
function render_tile(argument0) {

    var tile = argument0;
    var TEXEL = 1 / TEXTURE_SIZE;

    var xx = tile.xx * TILE_WIDTH;
    var yy = tile.yy * TILE_HEIGHT;
    var zz = tile.zz * TILE_DEPTH;

    var ts = get_active_tileset();

    if (Stuff.setting_view_entities) {
        var tex = Stuff.setting_view_texture ? sprite_get_texture(ts.picture, 0) : sprite_get_texture(b_tileset_textureless, 0)
        transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
        vertex_submit(tile.vbuffer, pr_trianglelist, tex);
        transform_reset();
    }

    if (Stuff.setting_view_wireframe) {
        transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
        vertex_submit(tile.vbuffer, pr_trianglelist, -1);
        transform_reset();
    }


}
