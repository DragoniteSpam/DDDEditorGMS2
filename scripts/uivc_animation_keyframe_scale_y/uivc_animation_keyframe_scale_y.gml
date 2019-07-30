/// @param UIInput

var input = argument0;
var keyframe = input.root.root.el_timeline.selected_keyframe;

if (keyframe && script_execute(input.validation, input.value)) {
    keyframe.yscale = real(input.value);
}