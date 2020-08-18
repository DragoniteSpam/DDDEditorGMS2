/// @param UIList
function uivc_list_data_property(argument0) {

	var list = argument0;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var listofthings = list.root.selected_data.properties;
    
	    if (listofthings[| selection] != list.root.selected_property) {
	        list.root.selected_property = listofthings[| selection];
	        dialog_data_type_disable(list.root);
	        dialog_data_type_enable_by_type(list.root);
	    }
	} else {
	    dialog_data_type_disable(list.root);
	}


}
