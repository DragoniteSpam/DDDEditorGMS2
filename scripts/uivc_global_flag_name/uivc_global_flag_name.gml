/// @param UIInput
function uivc_global_flag_name(argument0) {

	var input = argument0;
	var base_dialog = input.root;
	var selection = ui_list_selection(base_dialog.el_list);

	if (selection + 1) {
	    Stuff.all_asset_flags[| selection] = input.value;
	}


}
