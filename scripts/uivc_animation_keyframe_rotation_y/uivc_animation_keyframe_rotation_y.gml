/// @param UIInput
function uivc_animation_keyframe_rotation_y(argument0) {

    var input = argument0;
    var keyframe = input.root.root.el_timeline.selected_keyframe;

    if (keyframe) {
        keyframe.yrot = real(input.value);
    }


}
