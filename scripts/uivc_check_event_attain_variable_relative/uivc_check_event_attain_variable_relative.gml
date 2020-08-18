/// @param UICheckbox
function uivc_check_event_attain_variable_relative(argument0) {

	var checkbox = argument0;

	var data = checkbox.root.node.custom_data[| 2];
	data[| 0] = checkbox.value;


}
