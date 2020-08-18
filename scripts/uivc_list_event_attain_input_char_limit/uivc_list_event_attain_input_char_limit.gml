/// @param UIInput
function uivc_list_event_attain_input_char_limit(argument0) {

	var input = argument0;

	var data = input.root.node.custom_data[| 3];
	data[| 0] = real(input.value);


}
