/// @param UIList
function uivc_animation_keyframe_audio(argument0) {

	var list = argument0;
	var keyframe = list.root.root.root.root.el_timeline.selected_keyframe;
	var value = ui_list_selection(list);
	keyframe.audio = value ? list.entries[| value] : 0;


}
