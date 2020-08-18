/// @param UIRadio
function uivc_check_event_condition_comparison(argument0) {

	var radio = argument0;

	var data = radio.root.root.node.custom_data[| 2];
	data[| radio.root.root.index] = radio.value;


}
