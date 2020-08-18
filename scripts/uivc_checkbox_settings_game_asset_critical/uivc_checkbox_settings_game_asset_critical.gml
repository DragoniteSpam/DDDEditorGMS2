/// @param UICheckbox
function uivc_checkbox_settings_game_asset_critical(argument0) {

	var checkbox = argument0;
	var list = checkbox.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var file_data = list.entries[| selection];
	    file_data.critical = checkbox.value;
	}


}
