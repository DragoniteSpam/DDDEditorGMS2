event_inherited();

gpu_set_alphatestenable(true);
gpu_set_alphatestref(20);

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