/// @param UIButton
function omu_entity_data_enum_select(argument0) {

	var button = argument0;

	var dialog = dialog_create_data_enum_select(button);
	dialog.el_confirm.onmouseup = dc_entity_data_property_set_enum;


}
