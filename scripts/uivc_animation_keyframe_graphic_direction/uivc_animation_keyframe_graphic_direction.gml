/// @param UIInput
function uivc_animation_keyframe_graphic_direction(argument0) {

	var input = argument0;
	var keyframe = input.root.root.root.root.el_timeline.selected_keyframe;
	keyframe.graphic_direction = real(input.value);


}
