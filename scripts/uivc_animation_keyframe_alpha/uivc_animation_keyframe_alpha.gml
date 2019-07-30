/// @param UIInput

var input = argument0;
var keyframe = input.root.el_timeline.selected_keyframe;

if (script_execute(input.validation, input.value)) {
    keyframe.alpha = real(input.value);
}