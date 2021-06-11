/// @param UIListTimeline
/// @param xx
/// @param yy
function uii_animation_layers(argument0, argument1, argument2) {

    var timeline = argument0;
    var xx = argument1;
    var yy = argument2;

    var animation = timeline.root.active_animation;

    var x1 = timeline.x + xx;
    var y1 = timeline.y + yy;
    var x2 = x1 + timeline.moment_width * timeline.moment_slots;
    var y2 = y1 + timeline.height;

    var y3 = y2 + timeline.slots * timeline.height;

    var inbounds = mouse_within_rectangle_determine(x1, y2, x2, y3, timeline.adjust_view);

    if (keyboard_check_pressed(vk_delete)) {
        var timeline_layer = animation.GetLayer(timeline.selected_layer);
        if (timeline_layer) {
            var keyframe = timeline_layer.keyframes[| timeline.selected_moment];
            timeline_layer.keyframes[| timeline.selected_moment] = noone;
            if (timeline.selected_keyframe == keyframe) {
                animation_timeline_set_active_keyframe(timeline, noone);
            }
            if (keyframe) {
                instance_activate_object(keyframe);
                instance_destroy(keyframe);
            }
        }
    }

    // anything that should only be handled if the cursor is in bounds
    if (inbounds) {
        if (Controller.double_left) {
            var timeline_layer = animation.GetLayer(timeline.selected_layer);
            if (timeline_layer) {
                var keyframe = animation.GetKeyframe(timeline.selected_layer, timeline.selected_moment);
                if (!keyframe) {
                    var keyframe = animation_add_keyframe(animation, timeline.selected_layer, timeline.selected_moment);
                    animation_timeline_set_active_keyframe(timeline, keyframe);
                }
            }
        } else if (Controller.press_left) {
            if (!keyboard_check(vk_control)) {
                animation_timeline_set_active_keyframe(timeline, animation.GetKeyframe(timeline.selected_layer, timeline.selected_moment));
            }
        } else if (Controller.mouse_left) {
            if (keyboard_check(vk_control)) {
                if (timeline.selected_keyframe && (timeline.selected_keyframe.timeline_layer == timeline.selected_layer)) {
                    animation_set_keyframe_position(animation, timeline.selected_keyframe, timeline.selected_layer, timeline.selected_moment);
                }
            }
        }
    }


}
