/// @param UIButton
function dmu_create_data_event_entrypoint_finalize(argument0) {

	var button = argument0;

	var selection = ui_list_selection(button.root.el_list);
	if (selection + 1) {
	    var entrypoint = button.root.el_list.entries[| selection];
    
	    var root_element = button.root.root.root.root;
	    // @gml update chained accessors
	    var instance = root_element.instance;
	    ds_list_set(instance.values[| root_element.key], 0, entrypoint.GUID);
	    root_element.text = get_event_entrypoint_short_name(entrypoint);
	    root_element.tooltip = entrypoint.event.name + " / " + entrypoint.name;
	}

	dmu_dialog_commit(button);
	dmu_dialog_commit(button);


}
