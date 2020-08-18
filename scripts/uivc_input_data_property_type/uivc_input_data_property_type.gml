/// @param UIRadio
function uivc_input_data_property_type(argument0) {

	var radio = argument0;

	radio.root.root.selected_property.type = radio.value;

	dialog_data_type_disable(radio.root.root);
	dialog_data_type_enable_by_type(radio.root.root);


}
