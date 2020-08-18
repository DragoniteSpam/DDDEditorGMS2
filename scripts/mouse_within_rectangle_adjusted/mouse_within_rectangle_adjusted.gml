/// @param x1
/// @param y1
/// @param x2
/// @param y2
function mouse_within_rectangle_adjusted(argument0, argument1, argument2, argument3) {

	// for when a view x y isn't set at (0, 0) and you need things to be offset

	var camera = view_get_camera(view_current);
	var xoff = camera_get_view_x(camera);
	var yoff = camera_get_view_y(camera);

	return mouse_within_rectangle(argument0 - xoff, argument1 - yoff, argument2 - xoff, argument3 - yoff);


}
