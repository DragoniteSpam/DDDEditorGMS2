/// @param x
/// @param y
/// @param width
/// @param height
/// @param [xscale]
/// @param [yscale]
/// @param [color]
/// @param [alpha

var xx = argument[0];
var yy = argument[1];
var width = argument[2];
var height = argument[3];
var xscale = (argument_count > 4) ? argument[4] : 1;
var yscale = (argument_count > 5) ? argument[5] : 1;
var color = (argument_count > 6) ? argument[6] : c_white;
var alpha = (argument_count > 7) ? argument[7] : 1;

var s = sprite_get_width(b_tileset_checkers);

var xcount = width / s * xscale;
var ycount = height / s * yscale;

draw_primitive_begin_texture(pr_trianglelist, sprite_get_texture(b_tileset_checkers, 0));

draw_vertex_texture_colour(xx, yy, 0, 0, color, alpha);
draw_vertex_texture_colour(xx + width, yy, xcount, 0, color, alpha);
draw_vertex_texture_colour(xx + width, yy + height, xcount, ycount, color, alpha);

draw_vertex_texture_colour(xx + width, yy + height, xcount, ycount, color, alpha);
draw_vertex_texture_colour(xx, yy + height, 0, ycount, color, alpha);
draw_vertex_texture_colour(xx, yy, 0, 0, color, alpha);

draw_primitive_end();