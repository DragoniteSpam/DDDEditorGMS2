/// @param UIInput

var input = argument0;
var keyframe = input.root.root.el_timeline.selected_keyframe;

if (keyframe) {
    keyframe.alpha = real(input.value);
}