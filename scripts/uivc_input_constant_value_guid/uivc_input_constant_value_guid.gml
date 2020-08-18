/// @param UIList
function uivc_input_constant_value_guid(argument0) {

	var list = argument0;
	var base_dialog = list.root;
	var selection = ui_list_selection(base_dialog.el_list);

	if (selection + 1) {
	    Stuff.all_game_constants[| selection].value_guid = list.entries[| ui_list_selection(list)].GUID;
	}


}
