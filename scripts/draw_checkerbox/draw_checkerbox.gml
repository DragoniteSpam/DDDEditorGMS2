/// @description void draw_checkerbox(x, y, width, height);
/// @param x
/// @param y
/// @param width
/// @param height

var s=sprite_get_width(b_tileset_checkers);

var xcount=argument2/s;
var ycount=argument3/s;

draw_primitive_begin_texture(pr_trianglelist, sprite_get_texture(b_tileset_checkers, 0));

draw_vertex_texture(argument0, argument1, 0, 0);
draw_vertex_texture(argument0+argument2, argument1, xcount, 0);
draw_vertex_texture(argument0+argument2, argument1+argument3, xcount, ycount);

draw_vertex_texture(argument0+argument2, argument1+argument3, xcount, ycount);
draw_vertex_texture(argument0, argument1+argument3, 0, ycount);
draw_vertex_texture(argument0, argument1, 0, 0);

draw_primitive_end();
