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
var sw = surface_get_width(surface.surface);
var sh = surface_get_height(surface.surface);
var changed = false;
var mx = mouse_x_view - x1;
var my = mouse_y_view - y1;
var mxp = mouse_x_view_previous - x1;
var myp = mouse_y_view_previous - y1;

draw_rectangle_colour(1, 1, sw - 2, sh - 2, c_black, c_black, c_black, c_black, true);

switch (mode.doodle_tool) {
    case DoodleTools.PENCIL:
        #region
        if (Controller.mouse_left) {
            var c = mode.doodle_color_a;
            changed = true;
        } else if (Controller.mouse_right) {
            var c = mode.doodle_color_b;
            changed = true;
        }
        if (changed) {
            draw_line_width_color(mxp, myp, mx, my, mode.doodle_brush_size * 2, c, c);
            draw_circle_color(mxp, myp, mode.doodle_brush_size, c, c, false);
            draw_circle_color(mx, my, mode.doodle_brush_size, c, c, false);
        }
        #endregion
        break;
    case DoodleTools.FLOODFILL:
        #region
        if (Controller.mouse_left) {
            var c = mode.doodle_color_a;
            changed = true;
        } else if (Controller.mouse_right) {
            var c = mode.doodle_color_b;
            changed = true;
        }
        if (changed) {
            var base_color = buffer_get_pixel(surface.surface, mode.doodle_buffer, mx, my);
        }
        #endregion
        break;
}

if (changed) {
    surface_reset_target();
    buffer_get_surface(mode.doodle_buffer, surface.surface, buffer_surface_copy, 0, 0);
    surface_set_target(surface.surface);
}