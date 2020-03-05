/// @param UIList

var list = argument0;
var keyframe = list.root.root.root.root.el_timeline.selected_keyframe;
var value = ui_list_selection(list);
keyframe.graphic_mesh = value ? list.entries[| value] : 0;