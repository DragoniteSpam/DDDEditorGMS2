/// @param UIInput
function uivc_animation_keyframe_alpha(argument0) {

	var input = argument0;
	var keyframe = input.root.root.el_timeline.selected_keyframe;

	if (keyframe) {
	    keyframe.alpha = real(input.value);
	}


}
