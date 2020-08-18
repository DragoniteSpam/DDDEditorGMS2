/// @param UIInput
function uivc_input_event_attain_transfer_color(argument0) {

	var input = argument0;

	var data = input.root.node.custom_data[| 5];
	data[| 0] = input.value;


}
