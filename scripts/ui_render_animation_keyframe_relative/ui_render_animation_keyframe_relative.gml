/// @param UIButton
/// @param x
/// @param y

var button = argument0;
var xx = argument1;
var yy = argument2;

var animation = button.root.root.active_animation;
var keyframe = noone;
var original_text = button.text;

if (animation) {
	var timeline = button.root.root.el_timeline;
	var timeline_layer = ui_list_selection(button.root.root.el_layers);
	keyframe = (timeline_layer == noone) ? noone : animation_get_keyframe(animation, timeline_layer, timeline.playing_moment);

	button.text = button.text + ((keyframe && keyframe.relative && keyframe.relative < ds_list_size(animation.layers)) ? " " + animation.layers[| keyframe.relative].name : " (None)");
}

// we must abuse truthiness wherever possible
button.interactive = (keyframe && true);

ui_render_animation_keyframe_other(button, xx, yy);

button.text = original_text;