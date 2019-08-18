/// @param UIInput
/// @param x
/// @param y

var input = argument0;
var xx = argument1;
var yy = argument2;

var animation = input.root.root.active_animation;
var timeline = input.root.root.el_timeline;
var timeline_layer = ui_list_selection(input.root.root.el_layers);
var keyframe = (timeline_layer == noone) ? noone : animation_get_keyframe(animation, timeline_layer, timeline.playing_moment);

var kf_current = animation ? animation_get_keyframe(animation, timeline_layer, timeline.playing_moment) : noone;
var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[| kf_current.relative] : noone;

// we must abuse truthiness wherever possible
input.interactive = (keyframe && true);
input.root.tween_scale_x.interactive = input.interactive;
input.back_color = rel_current ? c_ui_select : c_white;

if (animation && timeline_layer != noone && !ui_is_active(input)) {
    input.value = string(animation_get_tween_scale_x(animation, timeline_layer, floor(timeline.playing_moment)) / (rel_current ? rel_current.xscale : 1));
}

ui_render_input(input, xx, yy);