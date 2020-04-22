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
var buffer = mode.doodle_buffer;
var sw = surface_get_width(surface.surface);
var sh = surface_get_height(surface.surface);
var changed = false;
var mx = floor(mouse_x_view - x1);
var my = floor(mouse_y_view - y1);
var mxp = floor(mouse_x_view_previous - x1);
var myp = floor(mouse_y_view_previous - y1);

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
            // this is very slow and enjoys endless issues with byte order (BGRA... apparently)
            /*var base_color = buffer_get_pixel(surface.surface, buffer, mx, my);
            if (c != base_color) {
                var points = ds_stack_create();
                // You can't push an array onto a stack! So we'll assume that you're not
                // going to have a surface larger than 65535 by 65535 instead.
                ds_stack_push(points, (mx << 16) | my);
                while (!ds_stack_empty(points)) {
                    var point = ds_stack_pop(points);
                    var px = point >> 16;
                    var py = point & 0xffff;
                    if (px < 0 || py < 0 || px >= sw || py >= sh) {
                        continue;
                    }
                    var pcolor = buffer_get_pixel(surface.surface, buffer, px, py);
                    if (pcolor == base_color) {
                        buffer_set_pixel(surface.surface, buffer, px, py, c);
                        ds_stack_push(points, ((px + 1) << 16) | py);
                        ds_stack_push(points, ((px - 1) << 16) | py);
                        ds_stack_push(points, (px << 16) | (py + 1));
                        ds_stack_push(points, (px << 16) | (py - 1));
                    }
                }
                ds_stack_destroy(points);
                surface_reset_target();
                buffer_set_surface(buffer, surface.surface, buffer_surface_copy, 0, 0);
                surface_set_target(surface.surface);
                changed = false;
            }*/
        }
        #endregion
        break;
}

if (changed) {
    surface_reset_target();
    buffer_get_surface(buffer, surface.surface, buffer_surface_copy, 0, 0);
    surface_set_target(surface.surface);
}