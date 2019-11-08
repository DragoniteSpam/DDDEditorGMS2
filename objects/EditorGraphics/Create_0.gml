event_inherited();

gpu_set_alphatestenable(true);
gpu_set_alphatestref(20);

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_colour();     // second color information is for extra data
vertex_format = vertex_format_end();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_basic = vertex_format_end();

grid = noone;
grid_centered = noone;

grid_sphere = noone;