/// @param UIButton
function omu_global_constant_remove(argument0) {

	var button = argument0;
	var list = button.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    instance_activate_object(Stuff.all_game_constants[| selection]);
	    instance_destroy(Stuff.all_game_constants[| selection]);
	    ds_list_delete(Stuff.all_game_constants, selection);
	}


}
