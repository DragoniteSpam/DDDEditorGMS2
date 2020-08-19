/// @param UIInput
function uivc_animation_keyframe_translation_z(argument0) {

    var input = argument0;
    var keyframe = input.root.root.el_timeline.selected_keyframe;

    if (keyframe) {
        keyframe.zz = real(input.value);
    }


}
