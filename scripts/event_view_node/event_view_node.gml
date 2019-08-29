/// @param DataEventNode
// snap the view to the specified node

// @todo scale with the window
var camera = view_get_camera(view_fullscreen);
camera_set_view_pos(camera, floor(argument0.x - room_width / 2), floor(argument0.y - room_height / 3));