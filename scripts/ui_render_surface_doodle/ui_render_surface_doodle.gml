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
var mode = Stuff.doodle;
var padding = 32;
var sw = surface_get_width(surface.surface);
var sh = surface_get_height(surface.surface);

draw_rectangle_colour(1, 1, sw - 2, sh - 2, c_black, c_black, c_black, c_black, true);

if (Controller.mouse_left) {
    draw_line_colour(mouse_x_view_previous - x1, mouse_y_view_previous - y1, mouse_x_view - x1, mouse_y_view - y1, c_red, c_red);
}