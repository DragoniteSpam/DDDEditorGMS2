function batch_tile(vbuff, wire, reflect, reflect_wire, tile) {
    var TEXEL = 1 / TEXTURE_SIZE;
    
    var xx = tile.xx * TILE_WIDTH;
    var yy = tile.yy * TILE_HEIGHT;
    var zz = tile.zz * TILE_DEPTH;
    
    var nx = 0;
    var ny = 0;
    var nz = 1;
    
    // texture coordinates go from 0...1, not 0...n, where n is the dimension
    // of the image in pixels
    var texture_width = Stuff.tile_size / TEXTURE_SIZE;
    var texture_height = Stuff.tile_size / TEXTURE_SIZE;
    
    var xtex = tile.tile_x * texture_width;
    var ytex = tile.tile_y * texture_height;
    
    var color = tile.tile_color;
    var alpha = tile.tile_alpha;
    
    if (vbuff) {
        vertex_point_complete(vbuff, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
        vertex_point_complete(vbuff, xx + TILE_WIDTH, yy, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + TEXEL, color, alpha);
        vertex_point_complete(vbuff, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
        
        vertex_point_complete(vbuff, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + texture_width - TEXEL, ytex + texture_height - TEXEL, color, alpha);
        vertex_point_complete(vbuff, xx, yy + TILE_HEIGHT, zz, nx, ny, nz, xtex + TEXEL, ytex + texture_height - TEXEL, color, alpha);
        vertex_point_complete(vbuff, xx, yy, zz, nx, ny, nz, xtex + TEXEL, ytex + TEXEL, color, alpha);
    }
    
    if (wire) {
        vertex_point_line(wire, xx, yy, zz, c_white, 1);
        vertex_point_line(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);
        
        vertex_point_line(wire, xx + TILE_WIDTH, yy, zz, c_white, 1);
        vertex_point_line(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
        
        vertex_point_line(wire, xx, yy, zz, c_white, 1);
        vertex_point_line(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
        
        vertex_point_line(wire, xx + TILE_WIDTH, yy + TILE_HEIGHT, zz, c_white, 1);
        vertex_point_line(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);
        
        vertex_point_line(wire, xx, yy + TILE_HEIGHT, zz, c_white, 1);
        vertex_point_line(wire, xx, yy, zz, c_white, 1);
    }
    
    // Tiles don't get reflected
}