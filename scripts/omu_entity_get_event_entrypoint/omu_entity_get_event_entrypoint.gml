/// @param UIButton
function omu_entity_get_event_entrypoint(argument0) {

	var button = argument0;
	var selection = ui_list_selection(button.root.el_list);
	var constant = Stuff.all_game_constants[| selection];

	if (constant) {
	    dialog_create_constant_get_event_entrypoint(button.root, constant);
	}


}
