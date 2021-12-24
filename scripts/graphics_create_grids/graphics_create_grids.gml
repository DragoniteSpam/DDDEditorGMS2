function graphics_create_grids() {
    var map = Stuff.map.active_map;
    var map_contents = map.contents;
    
    if (Stuff.graphics.grid) vertex_delete_buffer(Stuff.graphics.grid);
    Stuff.graphics.grid = vertex_create_buffer();
    vertex_begin(Stuff.graphics.grid, Stuff.graphics.vertex_format_wireframe);
    
    for (var i = 0; i <= map.xx; i++) {
        var xx = i * TILE_WIDTH;
        var yy = map.yy * TILE_HEIGHT;
        vertex_position_3d(Stuff.graphics.grid, xx, 0, 0);
        vertex_normal(Stuff.graphics.grid, 0, 0, 1);
        vertex_colour(Stuff.graphics.grid, c_white, 1);
        vertex_position_3d(Stuff.graphics.grid, xx, yy, 0);
        vertex_normal(Stuff.graphics.grid, 0, 0, 1);
        vertex_colour(Stuff.graphics.grid, c_white, 1);
    }
    
    for (var i = 0; i <= map.yy; i++) {
        var xx = map.xx * TILE_HEIGHT;
        var yy = i * TILE_WIDTH;
        vertex_position_3d(Stuff.graphics.grid, 0, yy, 0);
        vertex_normal(Stuff.graphics.grid, 0, 0, 1);
        vertex_colour(Stuff.graphics.grid, c_white, 1);
        vertex_position_3d(Stuff.graphics.grid, xx, yy, 0);
        vertex_normal(Stuff.graphics.grid, 0, 0, 1);
        vertex_colour(Stuff.graphics.grid, c_white, 1);
    }
    
    vertex_end(Stuff.graphics.grid);
    vertex_freeze(Stuff.graphics.grid);
}