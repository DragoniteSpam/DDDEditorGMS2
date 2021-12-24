function graphics_create_grids() {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    if (Stuff.graphics.grid) vertex_delete_buffer(Stuff.graphics.grid);
    Stuff.graphics.grid = vertex_create_buffer();
    vertex_begin(Stuff.graphics.grid, Stuff.graphics.vertex_format);
    
    for (var i = 0; i <= map.xx; i++) {
        vertex_point_line(Stuff.graphics.grid, i * TILE_WIDTH, 0, 0, c_white, 1);
        vertex_point_line(Stuff.graphics.grid, i * TILE_WIDTH, map.yy * TILE_HEIGHT, 0, c_white, 1);
    }
    
    for (var i = 0; i <= map.yy; i++) {
        vertex_point_line(Stuff.graphics.grid, 0, i * TILE_HEIGHT, 0, c_white, 1);
        vertex_point_line(Stuff.graphics.grid, map.xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
    }
    
    vertex_end(Stuff.graphics.grid);
    vertex_freeze(Stuff.graphics.grid);
}