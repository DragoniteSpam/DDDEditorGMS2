/// @param UIList
function uivc_list_map_data(argument0) {

	var list = argument0;

	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var data = list.entries[| selection];
	    dialog_map_data_type_disable(list.root);
	    dialog_map_data_enable_by_type(list.root);
	}


}
