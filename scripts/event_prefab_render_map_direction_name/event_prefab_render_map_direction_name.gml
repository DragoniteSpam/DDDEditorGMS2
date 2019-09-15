/// @param EventNode
/// @param index

var event = argument0;
var index = argument1;

// @todo gml update
var custom_data = event.custom_data[| 1];
var raw = custom_data[| 0];

switch (raw) {
	case 0: return "Down";
	case 1: return "Left";
	case 2: return "Right";
	case 3: return "Up";
}