event_inherited();

gpu_set_alphatestenable(true);
gpu_set_alphatestref(20);
gpu_set_tex_repeat(true);

vertex_format_begin();
format_size = 0;
vertex_format_add_position_3d();
format_size = format_size + 12;
vertex_format_add_normal();
format_size = format_size + 12;
vertex_format_add_texcoord();
format_size = format_size + 8;
vertex_format_add_colour();
format_size = format_size + 4;
vertex_format_add_colour();     // second color information is for extra data
format_size = format_size + 4;
vertex_format = vertex_format_end();

vertex_format_begin();
format_size_basic = 0;
vertex_format_add_position_3d();
format_size_basic = format_size_basic + 12;
vertex_format_add_normal();
format_size_basic = format_size_basic + 12;
vertex_format_add_texcoord();
format_size_basic = format_size_basic + 8;
vertex_format_add_colour();
format_size_basic = format_size_basic + 4;
vertex_format_basic = vertex_format_end();

grid = noone;
grid_centered = noone;
grid_sphere = noone;

mesh_preview_grid = vertex_create_buffer();
vertex_begin(mesh_preview_grid, vertex_format);

var s2 = 6;
var x1 = -s2 * TILE_WIDTH;
var y1 = -s2 * TILE_HEIGHT;
var x2 = -x1;
var y2 = -y1;

for (var i = 0; i <= 12; i++) {
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y1, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x1 + i * TILE_WIDTH, y2, 0, c_white, 1);
    
    vertex_point_line(mesh_preview_grid, x1, y1 + i * TILE_HEIGHT, 0, c_white, 1);
    vertex_point_line(mesh_preview_grid, x2, y1 + i * TILE_HEIGHT, 0, c_white, 1);
}

vertex_end(mesh_preview_grid);
vertex_freeze(mesh_preview_grid);

enum TileSelectorDisplayMode {
    PASSAGE,
    PRIORITY,
    FLAGS,
    TAGS,
}

enum TileSelectorOnClick {
    SELECT,
    MODIFY,
}