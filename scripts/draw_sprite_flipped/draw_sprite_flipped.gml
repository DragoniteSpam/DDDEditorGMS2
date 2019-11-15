/// @param sprite
/// @param index
/// @param x
/// @param y

var sprite = argument0;
var index = argument1;
var xx = argument2;
var yy = argument3;

draw_primitive_begin_texture(pr_trianglelist, sprite_get_texture(sprite, index));
var ww = sprite_get_width(sprite);
var hh = sprite_get_height(sprite);
draw_vertex_texture_colour(xx, yy + hh, 0, 0, c_white, 1);
draw_vertex_texture_colour(xx + ww, yy + hh, 1, 0, c_white, 1);
draw_vertex_texture_colour(xx + ww, yy, 1, 1, c_white, 1);
draw_vertex_texture_colour(xx + ww, yy, 1, 1, c_white, 1);
draw_vertex_texture_colour(xx, yy, 0, 1, c_white, 1);
draw_vertex_texture_colour(xx, yy + hh, 0, 0, c_white, 1);
draw_primitive_end();