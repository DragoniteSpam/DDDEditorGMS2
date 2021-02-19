function uivc_animation_keyframe_set_tween(radio) {
    var keyframe = radio.root.root.root.root.root.el_timeline.selected_keyframe;
    animation_set_keyframe_parameter_tween(keyframe, radio.root.param, radio.value);
}