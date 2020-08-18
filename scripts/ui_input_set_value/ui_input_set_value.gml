/// @param UIInput
/// @param value
function ui_input_set_value(argument0, argument1) {
	// because keyboard_string also needs to be set

	var input = argument0;
	var value = argument1;

	input.value = value;

	if (ui_is_active(input)) {
	    keyboard_string = value;
	}


}
