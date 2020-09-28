/// @param UIInput
function uivc_animation_keyframe_function(argument0) {

    var input = argument0;
    var keyframe = input.root.root.root.root.el_timeline.selected_keyframe;

    keyframe.event = input.value;


}
