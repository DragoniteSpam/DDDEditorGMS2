/// @param Dialog
/// @param [force?]

var dialog = argument[0];
var force = (argument_count > 1) ? argument[1] : false;

var map = Stuff.event.map;

if (map != Stuff.map.active_map) {
	instance_destroy(map.contents);
}

dialog_destroy();