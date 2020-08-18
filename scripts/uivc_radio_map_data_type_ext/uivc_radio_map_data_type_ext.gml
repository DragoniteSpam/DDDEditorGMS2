/// @param UIRadio
function uivc_radio_map_data_type_ext(argument0) {

	var radio = argument0;
	var base_dialog = radio.root.root.root.root; /* why me? */
	var map = Stuff.map.active_map;
	var selection = ui_list_selection(base_dialog.el_list);
	var offset = 0;
	var value = radio.value + offset;

	map.generic_data[| selection].type = value;
	base_dialog.el_data_type.value = value;

	dialog_map_data_type_disable(base_dialog);
	dialog_map_data_enable_by_type(base_dialog);


}
