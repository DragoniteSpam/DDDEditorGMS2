/// @param animation
/// @param layer
/// @param current-moment

var animation = argument0;
var timeline_layer = argument1;
var moment = argument2;

var kf_previous = animation_get_preivous_keyframe(animation, timeline_layer, moment);
var kf_next = animation_get_next_keyframe(animation, timeline_layer, moment);
var type = kf_previous[0] ? kf_previous[0].tween_zz : AnimationTweens.NONE;

// if no previous keyframe exists the value will always be the default (here, zero);
// if not next keyframe exists the value will always be the previous value
var value_previous = kf_previous[0] ? kf_previous[0].color : 0;
var value_next = kf_next[0] ? kf_next[0].color : value_previous;
var moment_previous = kf_previous[0] ? kf_previous[1] : 0;
var moment_next = kf_next[0] ? kf_next[1] : animation.moments;
var f = normalize(moment, moment_previous, moment_next);

// bgr
var r_previous = value_previous & 0x0000ff;
var g_previous = value_previous & 0x00ff00;
var b_previous = value_previous & 0xff0000;

var r_next = value_next & 0x0000ff;
var g_next = value_next & 0x00ff00;
var b_next = value_next & 0xff0000;

// only need to check for previous keyframe because if there is no next keyframe, the "next"
// value will be the same as previous and tweening will just output the same value anyway
var r_current = tween(r_previous, r_next, f, type);
var g_current = tween(g_previous, g_next, f, type);
var b_current = tween(b_previous, b_next, f, type);

return r_current | (g_current << 8) | (b_current << 16);