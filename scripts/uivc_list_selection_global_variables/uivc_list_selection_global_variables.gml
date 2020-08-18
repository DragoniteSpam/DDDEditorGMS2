/// @param UIList
function uivc_list_selection_global_variables(argument0) {

	var list = argument0;
	var selection = ui_list_selection(list);

	if (selection >= 0) {
	    var var_data = Stuff.variables[| selection];
	    var base_dialog = list.root;

	    ui_input_set_value(base_dialog.el_name, var_data[0]);
	    base_dialog.el_default.value = string(var_data[1]);
	}


}
