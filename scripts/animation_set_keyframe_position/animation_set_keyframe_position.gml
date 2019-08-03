/// @param DataAnimation
/// @param keyframe
/// @param layer
/// @param moment

var animation = argument0;
var keyframe = argument1;
var inst_layer = animation_get_layer(animation, argument2);
var moment = argument3;

inst_layer.keyframes[| keyframe.moment] = noone;
keyframe.moment = moment;
inst_layer.keyframes[| moment] = keyframe;

return keyframe;