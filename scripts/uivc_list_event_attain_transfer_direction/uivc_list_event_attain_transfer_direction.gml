/// @param UIRadioArray
function uivc_list_event_attain_transfer_direction(argument0) {

	var radio = argument0;

	var data = radio.root.root.node.custom_data[| 4];
	data[| 0] = radio.value;


}
