/// @param DataEvent
/// @param name
function event_get_node(argument0, argument1) {
	// @todo preferably replace this with a constant-time map lookup later

	for (var i = 0; i < ds_list_size(argument0.nodes); i++) {
	    if (argument1 == argument0.nodes[| i].name) {
	        return argument0.nodes[| i];
	    }
	}

	return noone;


}
