/// @param UIList
function uivc_animation_keyframe_relative(argument0) {

	var list = argument0;
	var keyframe = list.keyframe;

	// you can select your own layer, which doesn't make sense, but i won't bother stopping you
	keyframe.relative = ui_list_selection(list);


}
