/// @param DataAnimation
/// @param layer
/// @param moment

var animation = argument0;
var timeline_layer = argument1;
var moment = argument2;

var timeline_layer = animation_get_layer(animation, timeline_layer);
if (timeline_layer) {
    var keyframe = timeline_layer.keyframes[| moment];
    return keyframe ? keyframe : noone;
}

return noone;