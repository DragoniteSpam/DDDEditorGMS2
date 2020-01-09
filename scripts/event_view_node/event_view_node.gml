/// @param DataEventNode
// snap the view to the specified node

var node = argument0;

// @todo scale with the window
var camera = view_get_camera(view_fullscreen);
camera_set_view_pos(camera, floor(node.x - room_width / 2), floor(node.y - room_height / 3));
Stuff.event.active = node.event;

var index = ds_list_find_index(Stuff.all_events, node.event);
var event_list = Stuff.event.ui.t_events.el_event_list;
ui_list_deselect(event_list);
ui_list_select(event_list, index);