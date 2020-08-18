/// @param UIInput
function uivc_global_constant_name(argument0) {

	var input = argument0;
	var base_dialog = input.root;
	var selection = ui_list_selection(base_dialog.el_list);

	if (selection >= 0) {
	    Stuff.all_game_constants[| selection].name = input.value;
	}


}
