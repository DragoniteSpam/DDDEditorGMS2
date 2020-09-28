/// @param UIInput
function uivc_animation_keyframe_graphic_frame(argument0) {

    var input = argument0;
    var keyframe = input.root.root.root.root.el_timeline.selected_keyframe;
    keyframe.graphic_frame = real(input.value);


}
