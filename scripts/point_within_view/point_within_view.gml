/// @param view
/// @param x1
/// @param y1

var camera = view_get_camera(argument0);
var xx = argument1;
var yy = argument2;

return point_in_rectangle(xx, yy, camera_get_view_x(camera), camera_get_view_y(camera),
	camera_get_view_x(camera) + camera_get_view_width(camera),
	camera_get_view_y(camera) + camera_get_view_height(camera));