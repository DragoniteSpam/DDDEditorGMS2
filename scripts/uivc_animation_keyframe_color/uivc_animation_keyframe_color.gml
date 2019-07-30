/// @param UIColor

var color = argument0;
var keyframe = color.root.root.root.root.el_timeline.selected_keyframe;
color.root.root.root.root.el_keyframe.value = color.value;

if (keyframe) {
    keyframe.color = color.value;
}