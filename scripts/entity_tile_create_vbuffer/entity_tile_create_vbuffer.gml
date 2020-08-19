/// @param tile
function entity_tile_create_vbuffer(argument0) {

    var tile = argument0;

    var texture_width = 1 / (TEXTURE_SIZE / Stuff.tile_size);
    var texture_height = 1 / (TEXTURE_SIZE / Stuff.tile_size);

    var texx1 = tile.tile_x * texture_width;
    var texy1 = tile.tile_y * texture_height;
    var texx2 = (tile.tile_x + 1) * texture_width;
    var texy2 = (tile.tile_y + 1) * texture_height;

    var tw = TILE_WIDTH;
    var th = TILE_HEIGHT;

    var vbuffer = vertex_create_buffer();
    vertex_begin(vbuffer, Stuff.graphics.vertex_format);
    vertex_point_complete(vbuffer, 0, 0, 0, 0, 0, 1, texx1, texy1, tile.tile_color, tile.tile_alpha);
    vertex_point_complete(vbuffer, tw, 0, 0, 0, 0, 1, texx2, texy1, tile.tile_color, tile.tile_alpha);
    vertex_point_complete(vbuffer, tw, th, 0, 0, 0, 1, texx2, texy2, tile.tile_color, tile.tile_alpha);
    vertex_point_complete(vbuffer, tw, th, 0, 0, 0, 1, texx2, texy2, tile.tile_color, tile.tile_alpha);
    vertex_point_complete(vbuffer, 0, th, 0, 0, 0, 1, texx1, texy2, tile.tile_color, tile.tile_alpha);
    vertex_point_complete(vbuffer, 0, 0, 0, 0, 0, 1, texx1, texy1, tile.tile_color, tile.tile_alpha);
    vertex_end(vbuffer);

    return vbuffer;


}
