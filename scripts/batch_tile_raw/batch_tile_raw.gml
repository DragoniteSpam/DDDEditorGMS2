function batch_tile_raw(buffer, wire, x, y, z, tile_x, tile_y, color, alpha) {
    // this is much like batch_tile, except it bypasses the part where it actually needs an EntityTile,
    // and also writes the data straight into a regular buffer instead of a vertex buffer
    var TEXEL = 1 / TEXTURE_SIZE;
    
    var nx = 0;
    var ny = 0;
    var nz = 1;
    
    var tile_horizontal_count = TEXTURE_SIZE / Stuff.tile_size;
    var tile_vertical_count = TEXTURE_SIZE / Stuff.tile_size;
    
    var texture_width = 1 / tile_horizontal_count;
    var texture_height = 1 / tile_vertical_count;
    
    var xtex = tile_x * texture_width;
    var ytex = tile_y * texture_width;
    
    if (buffer) {
        vertex_point_complete_raw(buffer, x, y, z, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
        vertex_point_complete_raw(buffer, x + TILE_WIDTH, y, z, nx, ny, nz, xtex + texture_width - TEXEL, ytex + TEXEL, color, alpha);
        vertex_point_complete_raw(buffer, x + TILE_WIDTH, y + TILE_HEIGHT, z, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
        
        vertex_point_complete_raw(buffer, x + TILE_WIDTH, y + TILE_HEIGHT, z, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
        vertex_point_complete_raw(buffer, x, y + TILE_HEIGHT, z, nx, ny, nz, xtex + TEXEL, ytex + texture_height - TEXEL, color, alpha);
        vertex_point_complete_raw(buffer, x, y, z, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
    }
    
    if (wire) {
        vertex_point_line_raw(wire, x, y, z, c_white, 1);
        vertex_point_line_raw(wire, x + TILE_WIDTH, y, z, c_white, 1);
        
        vertex_point_line_raw(wire, x + TILE_WIDTH, y, z, c_white, 1);
        vertex_point_line_raw(wire, x + TILE_WIDTH, y + TILE_HEIGHT, z, c_white, 1);
        
        vertex_point_line_raw(wire, x, y, z, c_white, 1);
        vertex_point_line_raw(wire, x + TILE_WIDTH, y + TILE_HEIGHT, z, c_white, 1);
        
        vertex_point_line_raw(wire, x + TILE_WIDTH, y + TILE_HEIGHT, z, c_white, 1);
        vertex_point_line_raw(wire, x, y + TILE_HEIGHT, z, c_white, 1);
        
        vertex_point_line_raw(wire, x, y + TILE_HEIGHT, z, c_white, 1);
        vertex_point_line_raw(wire, x, y, z, c_white, 1);
    }
    
    // tiles don't get reflected
}