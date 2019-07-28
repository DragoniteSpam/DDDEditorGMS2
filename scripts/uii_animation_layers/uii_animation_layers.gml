/// @param UIListTimeline
/// @param xx
/// @param yy

var timeline = argument0;
var xx = argument1;
var yy = argument2;

var animation = timeline.root.active_animation;

var x1 = timeline.x + xx;
var y1 = timeline.y + yy;
var x2 = x1 + timeline.moment_width * timeline.moment_slots;
var y2 = y1 + timeline.height;

var y3 = y2 + timeline.slots * timeline.height;

var inbounds = mouse_within_rectangle_determine(timeline.check_view, x1, y2, x2, y3);

if (keyboard_check_pressed(vk_delete)) {
    if (timeline.selected_layer < ds_list_size(animation.layers)) {
        var timeline_layer = animation.layers[| timeline.selected_layer];
        if (timeline_layer) {
            var keyframe = timeline_layer.keyframes[| timeline.selected_moment];
            timeline_layer.keyframes[| timeline.selected_moment] = noone;
            if (keyframe) {
                instance_activate_object(keyframe);
                instance_destroy(keyframe);
            }
        }
    }
}