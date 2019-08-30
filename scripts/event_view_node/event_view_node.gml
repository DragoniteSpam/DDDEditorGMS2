/// @param DataEventNode
// snap the view to the specified node

var node = argument0;

// @todo scale with the window
var camera = view_get_camera(view_fullscreen);
camera_set_view_pos(camera, floor(node.x - room_width / 2), floor(node.y - room_height / 3));