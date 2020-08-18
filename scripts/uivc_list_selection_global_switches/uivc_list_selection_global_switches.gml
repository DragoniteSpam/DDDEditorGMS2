/// @param UIList
function uivc_list_selection_global_switches(argument0) {

	var list = argument0;

	var selection = ui_list_selection(list);
	var sw_data = Stuff.switches[| selection];
	var base_dialog = list.root;

	ui_input_set_value(base_dialog.el_name, sw_data[0]);
	base_dialog.el_default.value = sw_data[1];


}
