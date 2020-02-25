/// @param UIRenderSurface
/// @param x1
/// @param y1
/// @param x2
/// @param y2

var surface = argument0;
var x1 = argument1;
var y1 = argument2;
var x2 = argument3;
var y2 = argument4;

draw_clear(c_white);
draw_rectangle_colour(1, 1, surface_get_width(surface.surface) - 2, surface_get_height(surface.surface) - 2, c_black, c_black, c_black, c_black, true);

draw_text(32, 32, "text");