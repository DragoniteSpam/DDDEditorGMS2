/// @param UIInput
function uivc_animation_keyframe_translation_y(argument0) {

    var input = argument0;
    var keyframe = input.root.root.el_timeline.selected_keyframe;

    if (keyframe) {
        keyframe.yy = real(input.value);
    }


}
