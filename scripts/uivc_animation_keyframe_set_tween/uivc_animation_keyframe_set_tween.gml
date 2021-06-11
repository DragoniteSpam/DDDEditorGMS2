function uivc_animation_keyframe_set_tween(radio) {
    var keyframe = radio.root.root.root.root.root.el_timeline.selected_keyframe;
    keyframe.SetParameterTween(radio.root.param, radio.value);
}