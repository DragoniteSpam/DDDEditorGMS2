/// @param layer
/// @param moment

var timeline_layer = argument0;
var moment = argument1;

if (timeline_layer) {
    var keyframe = timeline_layer.keyframes[| moment];
    return keyframe ? keyframe : noone;
}

return noone;