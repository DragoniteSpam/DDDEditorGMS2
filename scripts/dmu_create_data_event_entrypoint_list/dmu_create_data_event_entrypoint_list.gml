/// @param Dialog
function dmu_create_data_event_entrypoint_list(argument0) {

	var dialog = argument0;
	var selection = ui_list_selection(dialog.root.el_list);

	if (selection + 1) {
	    dialog.event = Stuff.all_events[| selection];
	    dialog_create_data_get_event_entrypoint(dialog);
	} else {
	    dialog_destroy();
	}


}
