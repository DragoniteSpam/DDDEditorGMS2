/// @param view
/// @param x1
/// @param y1
/// @param x2
/// @param y2

var camera = view_get_camera(argument0);
var x1 = argument1;
var y1 = argument2;
var x2 = argument3;
var y2 = argument4;

return rectangle_in_rectangle(x1, y1, x2, y2,
	camera_get_view_x(camera), camera_get_view_y(camera),
	camera_get_view_x(camera) + camera_get_view_width(camera),
	camera_get_view_y(camera) + camera_get_view_height(camera));