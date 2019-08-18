/// @param animation
/// @param layer
/// @param current-moment

var animation = argument0;
var timeline_layer = argument1;
var moment = argument2;

var kf_current = noone;
var kf_previous = noone;
var kf_next = noone;

kf_current = animation_get_keyframe(animation, timeline_layer, moment);
do {
    kf_previous = animation_get_preivous_keyframe(animation, timeline_layer, kf_previous ? kf_previous.moment : moment);
} until (!kf_previous || kf_previous.tween_zz != AnimationTweens.IGNORE);
do {
    kf_next = animation_get_next_keyframe(animation, timeline_layer, kf_next ? kf_next.moment : moment);
} until (!kf_next || kf_next.tween_zz != AnimationTweens.IGNORE);

var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[| kf_current.relative] : noone;
var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[| kf_previous.relative] : noone;
var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[| kf_next.relative] : noone;

// if no previous keyframe exists the value will always be the default (here, zero);
// if not next keyframe exists the value will always be the previous value
var value_default = animation_get_layer(animation, timeline_layer).zz;
var value_now = (kf_current ? kf_current.zz : value_default) + (rel_current ? rel_current.zz : 0);
var value_previous = (kf_previous ? kf_previous.zz : value_default) + (rel_previous ? rel_previous.zz : 0);
var value_next = (kf_next ? kf_next.zz : (animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.zz : 0);
var moment_previous = kf_previous ? kf_previous.moment : 0;
var moment_next = kf_next ? kf_next.moment : animation.moments;
var f = normalize(moment, moment_previous, moment_next);

if (kf_current) {
    return value_now;
}

// only need to check for previous keyframe because if there is no next keyframe, the "next"
// value will be the same as previous and tweening will just output the same value anyway
return tween(value_previous, value_next, f, kf_previous ? kf_previous.tween_zz : AnimationTweens.NONE);