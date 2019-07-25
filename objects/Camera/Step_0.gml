/// @description Preliminary stuff

MOUSE_X = window_mouse_get_x();
MOUSE_Y = window_mouse_get_y();

/*
 * Overlay view
 */

var ww = window_get_width();
var hh = window_get_height();
var camera_overlay = view_get_camera(view_overlay);
camera_set_view_pos(camera_overlay, 0, 0);
camera_set_view_size(camera_overlay, ww, hh);
view_set_xport(view_overlay, 0);
view_set_yport(view_overlay, 0);
view_set_wport(view_overlay, ww);
view_set_hport(view_overlay, hh);