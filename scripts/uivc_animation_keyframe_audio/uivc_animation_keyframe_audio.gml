/// @param UIList

var list = argument0;
var keyframe = list.root.root.root.root.el_timeline.selected_keyframe;

keyframe.audio = list.entries[| ui_list_selection(list)];