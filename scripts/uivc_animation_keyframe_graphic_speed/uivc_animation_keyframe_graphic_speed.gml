/// @param UIInput

var input = argument0;
var keyframe = input.root.root.root.root.el_timeline.selected_keyframe;

if (validate_double(input.value)) {
    keyframe.graphic_speed = real(input.value);
}