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

// we must abuse truthiness wherever possible
input.interactive = (keyframe && true);
input.root.tween_translate_z.interactive = input.interactive;

if (animation && timeline_layer != noone && !ui_is_active(input)) {
    input.value = string(animation_get_tween_translate_z(animation, timeline_layer, floor(timeline.playing_moment)));
}

ui_render_input(input, xx, yy);