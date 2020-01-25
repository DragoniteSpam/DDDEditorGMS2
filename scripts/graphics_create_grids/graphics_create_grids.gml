// mild spaghetti - grid with origin in the corner

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

if (Stuff.graphics.grid_centered) vertex_delete_buffer(Stuff.graphics.grid_centered);
Stuff.graphics.grid_centered = vertex_create_buffer();
vertex_begin(Stuff.graphics.grid_centered, Stuff.graphics.vertex_format);

// grid
var xx = map.xx / 2;
var yy = map.yy / 2;

for (var i = -xx; i <= xx; i++) {
    if (i != 0) {
        vertex_point_line(Stuff.graphics.grid_centered, i * TILE_WIDTH, -yy * TILE_HEIGHT, 0, c_white, 1);
        vertex_point_line(Stuff.graphics.grid_centered, i * TILE_WIDTH, yy * TILE_HEIGHT, 0, c_white, 1);
    }
}

for (var i = -yy; i <= yy; i++) {
    if (i != 0) {
        vertex_point_line(Stuff.graphics.grid_centered, -xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
        vertex_point_line(Stuff.graphics.grid_centered, xx * TILE_WIDTH, i * TILE_HEIGHT, 0, c_white, 1);
    }
}
    
vertex_end(Stuff.graphics.grid_centered);
vertex_freeze(Stuff.graphics.grid_centered);