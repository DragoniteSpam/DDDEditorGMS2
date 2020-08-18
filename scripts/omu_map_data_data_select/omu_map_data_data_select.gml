/// @param UIButton
function omu_map_data_data_select(argument0) {

	var button = argument0;

	var dialog = dialog_create_data_data_select(button);
	dialog.el_confirm.onmouseup = dc_map_data_property_set_data;


}
