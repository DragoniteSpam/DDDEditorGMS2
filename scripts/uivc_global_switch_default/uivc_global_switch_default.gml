/// @param UIList
function uivc_global_switch_default(argument0) {

	var base_dialog = argument0.root;
	var selection = ui_list_selection(base_dialog.el_list);

	if (selection >= 0) {
	    var sw_data = Stuff.switches[| selection];
	    var value = base_dialog.el_default.value;

	    sw_data[@ 1] = value;
	    base_dialog.el_list.entries[| selection] = sw_data[@ 0] + ": " + Stuff.tf[sw_data[@ 1]];
	}


}
