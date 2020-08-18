/// @param Data
/// @param [value]
/// @param [force]
function guid_set() {

	var data = argument[0];
	var addition = (argument_count > 1) ? argument[1] : data.GUID;
	var force = (argument_count > 2) ? argument[2] : false;

	// almost all data is automatically created with a GUID, so remove it
	if (ds_map_exists(Stuff.all_guids, addition)) {
	    ds_map_delete(Stuff.all_guids, addition);
	}

	// if there's a collision, you ought to be informed (and explode)
	if (ds_map_exists(Stuff.all_guids, addition)) {
	    show_error("guid conflict: " + data.name + " is trying to overwrite " + guid_get(addition).name + " [" + string(addition) + "]", false)
	}

	Stuff.all_guids[? addition] = data;
	data.GUID = addition;

	return true;


}
