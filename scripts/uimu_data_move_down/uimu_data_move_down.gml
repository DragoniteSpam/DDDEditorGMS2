/// @param UIThing
function uimu_data_move_down(argument0) {

	var thing = argument0;

	var data = guid_get(thing.root.active_type_guid);
	var selection = ui_list_selection(thing.root.el_instances);
	var instance = data.instances[| selection];

	if (data && instance && (selection < ds_list_size(data.instances) - 1)) {
	    var t = data.instances[| selection + 1];
	    data.instances[| selection + 1] = instance;
	    data.instances[| selection] = t;
	    ui_list_deselect(thing.root.el_instances);
	    ui_list_select(thing.root.el_instances, selection + 1, true);
	}


}
