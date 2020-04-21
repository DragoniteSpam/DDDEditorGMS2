/// @param EntityTile

var tile = argument0;
var TEXEL = 1 / TEXTURE_SIZE;

var xx = tile.xx * TILE_WIDTH;
var yy = tile.yy * TILE_HEIGHT;
var zz = tile.zz * TILE_DEPTH;

var ts = get_active_tileset();

// todo correct normal calculation, and MAYBE normal smoothing, although
// i'm pretty sure that's going to be really expensive unless you bake it
// into the likely future map editing tool
var nx = 0;
var ny = 0;
var nz = 1;

var tile_horizontal_count = TEXTURE_SIZE / Stuff.tile_size;
var tile_vertical_count = TEXTURE_SIZE / Stuff.tile_size;

// texture coordinates go from 0...1, not 0...n, where n is the dimension
// of the image in pixels
var texture_width = 1 / tile_horizontal_count;
var texture_height = 1 / tile_vertical_count;

var xtex = tile.tile_x * texture_width;
var ytex = tile.tile_y * texture_height;

var color = tile.tile_color;
var alpha = tile.tile_alpha;

if (Stuff.setting_view_entities) {
    var tex = Stuff.setting_view_texture ? sprite_get_texture(ts.master, 0) : sprite_get_texture(b_tileset_textureless, 0)
    transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
    vertex_submit(tile.vbuffer, pr_trianglelist, tex);
    transform_reset();
}

if (Stuff.setting_view_wireframe) {
    transform_set(xx, yy, zz, 0, 0, 0, 1, 1, 1);
    vertex_submit(tile.vbuffer, pr_trianglelist, -1);
    transform_reset();
}