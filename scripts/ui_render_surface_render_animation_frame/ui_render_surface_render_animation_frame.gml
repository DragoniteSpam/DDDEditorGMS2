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

var ww = x2 - x1;
var hh = y2 - y1;

draw_clear(c_black);

draw_line_colour(0, hh / 2, ww, hh / 2, c_white, c_white);
draw_line_colour(ww / 2, 0, ww / 2, hh, c_white, c_white);