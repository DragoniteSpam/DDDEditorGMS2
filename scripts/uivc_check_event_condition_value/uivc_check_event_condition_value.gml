/// @param UIThing
function uivc_check_event_condition_value(argument0) {

	var thing = argument0;

	var data = thing.root.node.custom_data[| 3];
	data[| thing.root.index] = thing.value;


}
