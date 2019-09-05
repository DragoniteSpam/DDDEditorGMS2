/// @param view
/// @param x1
/// @param y1

var camera = view_get_camera(argument0);
var xx = argument1;
var yy = argument2;

return point_in_rectangle(xx, yy, view_get_xport(argument0), view_get_yport(argument0),
	view_get_xport(argument0) + view_get_wport(argument0),
	view_get_yport(argument0) + view_get_hport(argument0));