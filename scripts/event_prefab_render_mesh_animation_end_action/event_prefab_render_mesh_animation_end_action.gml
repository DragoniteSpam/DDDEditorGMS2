/// @param EventNode
/// @param index

var event = argument0;
var index = argument1;

// @gml update
var custom_data = event.custom_data[| 1];
var raw = custom_data[| 0];

switch (raw) {
    case AnimationEndActions.STOP: return "Stop";
    case AnimationEndActions.LOOP: return "Loop";
    case AnimationEndActions.REVERSE: return "Reverse";
}