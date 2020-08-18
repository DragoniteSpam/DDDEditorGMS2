/// @param UIRadioArray
function uivc_list_event_attain_self_switch_index(argument0) {

	var radio = argument0;

	var data = radio.root.root.node.custom_data[| 1];
	data[| 0] = radio.value;


}
