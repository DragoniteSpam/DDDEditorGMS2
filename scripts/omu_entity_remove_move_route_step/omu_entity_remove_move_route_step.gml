/// @param UIThing
function omu_entity_remove_move_route_step(argument0) {

	var thing = argument0;

	var index = ui_list_selection(thing.root.el_steps);
	ui_list_deselect(thing.root.el_steps);

	if (index + 1) {
	    move_route_update_buffer(thing.root.route);
	    ds_list_delete(thing.root.route.steps, index);
	}


}
