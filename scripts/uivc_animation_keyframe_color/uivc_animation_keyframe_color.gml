/// @param UIColor
function uivc_animation_keyframe_color(argument0) {

    var color = argument0;
    var keyframe = color.root.root.el_timeline.selected_keyframe;
    color.root.root.el_keyframe.value = color.value;

    if (keyframe) {
        keyframe.color = color.value;
    }


}
