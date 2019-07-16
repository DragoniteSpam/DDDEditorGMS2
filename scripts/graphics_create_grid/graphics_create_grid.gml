// mild spaghetti

with (Camera) {
    if (grid) {
        vertex_delete_buffer(grid);
    }
    
    grid = vertex_create_buffer();
    
    vertex_begin(grid, vertex_format_line);
    
    // grid
    for (var i = 0; i <= ActiveMap.xx; i++) {
        vertex_point_line(grid, i * TILE_WIDTH, 0, 0, c_white, 1);
        vertex_point_line(grid, i * TILE_WIDTH, ActiveMap.yy * TILE_HEIGHT, 0, c_white, 1);
    }
    
    for (var i = 0; i <= ActiveMap.yy; i++) {
        vertex_point_line(grid, 0, i * TILE_HEIGHT, 0, c_white, 1);
        vertex_point_line(grid, ActiveMap.xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
    }
    
    // axes
    vertex_point_line(grid, 0, 0, 0, c_red, 1);
    vertex_point_line(grid, MILLION, 0, 0, c_red, 1);
    
    vertex_point_line(grid, 0, 0, 0, c_green, 1);
    vertex_point_line(grid, 0, MILLION, 0, c_green, 1);
    
    vertex_point_line(grid, 0, 0, 0, c_blue, 1);
    vertex_point_line(grid, 0, 0, MILLION, c_blue, 1);
    
    vertex_end(grid);
    vertex_freeze(grid);
}