/// @param UIInput
function uivc_global_variable_default(argument0) {

	var input = argument0;
	var base_dialog = input.root;
	var selection = ui_list_selection(base_dialog.el_list);

	var selection = ui_list_selection(base_dialog.el_list);

	if (selection >= 0) {
	    var var_data = Stuff.variables[| selection];
	    var_data[@ 1] = real(input.value);
	    input.root.el_list.entries[| selection] = var_data[@ 0] + ": " + string(var_data[@ 1]);
	}


}
