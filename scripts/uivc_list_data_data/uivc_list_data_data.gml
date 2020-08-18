/// @param UIList
function uivc_list_data_data(argument0) {

	var list = argument0;

	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var listofthings = Stuff.all_data;
	    if (listofthings[| selection] != list.root.selected_data) {
	        list.root.selected_data = listofthings[| selection];
	        list.root.selected_property = noone;
        
	        ui_list_deselect(list.root.el_list_p);
        
	        dialog_data_type_disable(list.root);
        
	        list.root.el_data_name.interactive = true;
	        list.root.el_add_p.interactive = true;
	        list.root.el_remove_p.interactive = true;
        
	        ui_input_set_value(list.root.el_data_name, list.root.selected_data.name);
        
	        list.root.el_list_p.index = 0;
	    }
	}


}
