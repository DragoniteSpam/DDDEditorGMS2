with (Camera) {
    /*
     * mild spaghetti - grid with origin in the corner
     */

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

    /*
     * mild spaghetti - grid with origin in the center
     */

    if (grid_centered) {
        vertex_delete_buffer(grid_centered);
    }
    
    grid_centered = vertex_create_buffer();
    
    vertex_begin(grid_centered, vertex_format_line);
    
    // grid
    var xx = ActiveMap.xx / 2;
    var yy = ActiveMap.yy / 2;
    
    for (var i = -xx; i <= xx; i++) {
        if (i != 0) {
            vertex_point_line(grid_centered, i * TILE_WIDTH, -yy * TILE_HEIGHT, 0, c_white, 1);
            vertex_point_line(grid_centered, i * TILE_WIDTH, yy * TILE_HEIGHT, 0, c_white, 1);
        }
    }
    
    for (var i = -yy; i <= yy; i++) {
        if (i != 0) {
            vertex_point_line(grid_centered, -xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
            vertex_point_line(grid_centered, xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
        }
    }
    
    // axes
    vertex_point_line(grid_centered, -MILLION, 0, 0, c_red, 1);
    vertex_point_line(grid_centered, MILLION, 0, 0, c_red, 1);
    
    vertex_point_line(grid_centered, 0, -MILLION, 0, c_green, 1);
    vertex_point_line(grid_centered, 0, MILLION, 0, c_green, 1);
    
    vertex_point_line(grid_centered, 0, 0, 0, c_blue, 1);
    vertex_point_line(grid_centered, 0, 0, MILLION, c_blue, 1);
    
    vertex_end(grid_centered);
    vertex_freeze(grid_centered);
}