function batch_tile_raw(buffer, x, y, z, tile_x, tile_y, color, alpha) {
    // this is much like batch_tile, except it bypasses the part where it actually needs an EntityTile,
    // and also writes the data straight into a regular buffer instead of a vertex buffer
    var TEXEL_WIDTH = 1 / TEXTURE_WIDTH;
    var TEXEL_HEIGHT = 1 / TEXTURE_HEIGHT;
    
    var nx = 0;
    var ny = 0;
    var nz = 1;
    
    var tile_horizontal_count = TEXTURE_WIDTH / Stuff.tile_size;
    var tile_vertical_count = TEXTURE_HEIGHT / Stuff.tile_size;
    
    var texture_width = 1 / tile_horizontal_count;
    var texture_height = 1 / tile_vertical_count;
    
    var xtex = tile_x * texture_width;
    var ytex = tile_y * texture_height;
    
    if (buffer) {
        vertex_point_complete_raw(buffer, x, y, z, nx, ny, nz, xtex + TEXEL_WIDTH, ytex + TEXEL_HEIGHT, color, alpha);
        vertex_point_complete_raw(buffer, x + TILE_WIDTH, y, z, nx, ny, nz, xtex + texture_width - TEXEL_WIDTH, ytex + TEXEL_HEIGHT, color, alpha);
        vertex_point_complete_raw(buffer, x + TILE_WIDTH, y + TILE_HEIGHT, z, nx, ny, nz, xtex + texture_width - TEXEL_WIDTH, ytex + texture_height - TEXEL_HEIGHT, color, alpha);
        
        vertex_point_complete_raw(buffer, x + TILE_WIDTH, y + TILE_HEIGHT, z, nx, ny, nz, xtex + texture_width - TEXEL_WIDTH, ytex + texture_height - TEXEL_HEIGHT, color, alpha);
        vertex_point_complete_raw(buffer, x, y + TILE_HEIGHT, z, nx, ny, nz, xtex + TEXEL_WIDTH, ytex + texture_height - TEXEL_HEIGHT, color, alpha);
        vertex_point_complete_raw(buffer, x, y, z, nx, ny, nz, xtex + TEXEL_WIDTH, ytex + TEXEL_HEIGHT, color, alpha);
    }
}