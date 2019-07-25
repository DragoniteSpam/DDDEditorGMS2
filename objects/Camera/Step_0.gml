/// @description Preliminary stuff

MOUSE_X = window_mouse_get_x();
MOUSE_Y = window_mouse_get_y();

/*
 * Overlay view
 */

var ww = window_get_width();
var hh = window_get_height();
var camera_overlay = view_get_camera(view_overlay);
/*__view_set(e__VW.XView, view_overlay, 0)
__view_set(e__VW.YView, view_overlay, 0)
__view_set(e__VW.WView, view_overlay, ww)
__view_set(e__VW.HView, view_overlay, hh)
__view_set(e__VW.XPort, view_overlay, 0)
__view_set(e__VW.YPort, view_overlay, 0)
__view_set(e__VW.WPort, view_overlay, ww)
__view_set(e__VW.HPort, view_overlay, hh)*/
camera_set_view_pos(camera_overlay, 0, 0);
camera_set_view_size(camera_overlay, ww, hh);
view_set_xport(view_overlay, 0);
view_set_yport(view_overlay, 0);
view_set_wport(view_overlay, ww);
view_set_hport(view_overlay, hh);