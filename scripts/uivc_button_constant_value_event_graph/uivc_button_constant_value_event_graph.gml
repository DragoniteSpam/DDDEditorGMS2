/// @param UIButton
function uivc_button_constant_value_event_graph(argument0) {

	var button = argument0;
	var selection = ui_list_selection(button.root.el_list);
	var constant = Stuff.all_game_constants[| selection];

	if (constant) {
	    dialog_create_constant_get_event_graph(button.root, constant);
	}


}
