/// @param UIInputColor
/// @param x
/// @param y

var input = argument0;
var xx = argument1;
var yy = argument2;

var animation = input.root.root.active_animation;
var keyframe = noone;

if (animation) {
	var timeline = input.root.root.el_timeline;
	var timeline_layer = ui_list_selection(input.root.root.el_layers);
	keyframe = (timeline_layer == noone) ? noone : animation_get_keyframe(animation, timeline_layer, timeline.playing_moment);
}

// we must abuse truthiness wherever possible
input.interactive = (keyframe && true);
input.root.tween_color.interactive = input.interactive;

if (animation && timeline_layer != noone && !ui_is_active(input)) {
    input.value = animation_get_tween_color(animation, timeline_layer, floor(timeline.playing_moment));
}

ui_render_color_picker(input, xx, yy);