/// @param UIRadio

var radio = argument0;
var keyframe = radio.root.root.root.root.root.el_timeline.selected_keyframe;

animation_set_keyframe_parameter_tween(keyframe, radio.root.param, radio.value);