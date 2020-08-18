/// @param UIInput
function uivc_animation_keyframe_scale_z(argument0) {

	var input = argument0;
	var keyframe = input.root.root.el_timeline.selected_keyframe;

	if (keyframe) {
	    keyframe.zscale = real(input.value);
	}


}
