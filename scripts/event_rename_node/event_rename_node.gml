/// @param event
/// @param node
/// @param new-name
function event_rename_node(argument0, argument1, argument2) {

	var event = argument0;
	var node = argument1;
	var new_name = argument2;

	// it attempts to, anyway
	if (validate_string_event_name(new_name)) {
	    ds_map_delete(event.name_map, node.name);
	    ds_map_add(event.name_map, new_name, node);
	    node.name = new_name;
	}


}
