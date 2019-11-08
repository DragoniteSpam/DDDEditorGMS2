/// @param Dialog
/// @param [force?]

var dialog = argument[0];
var force = (argument_count > 1) ? argument[1] : false;

var map = Camera.event_map;

if (map != Stuff.map.active_map) {
	instance_destroy(map.contents);
}

dialog_destroy();