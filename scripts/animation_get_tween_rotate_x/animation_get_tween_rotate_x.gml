/// @param animation
/// @param layer
/// @param current-moment

var animation = argument0;
var timeline_layer = argument1;
var moment = argument2;

var kf_previous = animation_get_preivous_keyframe(animation, timeline_layer, moment);
var kf_next = animation_get_next_keyframe(animation, timeline_layer, moment);
    
// if no previous keyframe exists the value will always be the default (here, zero);
// if not next keyframe exists the value will always be the previous value
var value_previous = kf_previous[0] ? kf_previous[0].xrot : 0;
var value_next = kf_next[0] ? kf_next[0].xrot : value_previous;
var moment_previous = kf_previous[0] ? kf_previous[1] : 0;
var moment_next = kf_next[0] ? kf_next[1] : animation.moments;
var f = normalize(moment, moment_previous, moment_next);
    
// only need to check for previous keyframe because if there is no next keyframe, the "next"
// value will be the same as previous and tweening will just output the same value anyway
return tween(value_previous, value_next, f, kf_previous[0] ? kf_previous[0].tween_xrot : AnimationTweens.NONE);