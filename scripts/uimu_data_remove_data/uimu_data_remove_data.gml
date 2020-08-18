/// @param UIThing
function uimu_data_remove_data(argument0) {

	var thing = argument0;

	var data = guid_get(thing.root.active_type_guid);
	var selection = ui_list_selection(thing.root.el_instances);
	var instance = data.instances[| selection];
	ui_list_deselect(thing.root.el_instances);

	if (data && instance) {
	    instance_activate_object(instance);
	    instance_destroy(instance);
    
	    ds_list_delete(data.instances, selection);
    
	    ui_init_game_data_refresh();
	}


}
