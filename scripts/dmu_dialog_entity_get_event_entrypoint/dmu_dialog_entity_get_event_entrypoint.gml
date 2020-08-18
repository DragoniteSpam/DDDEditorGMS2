/// @param UIButton
function dmu_dialog_entity_get_event_entrypoint(argument0) {

	var button = argument0;

	var selection = ui_list_selection(button.root.el_list);
	var entrypoint = button.root.el_list.entries[| selection];

	if (entrypoint) {
	    var index = ui_list_selection(Stuff.map.ui.element_entity_events);
	    var list = Stuff.map.selected_entities;
	    var page = list[| 0].object_events[| index];
    
	    page.event_entrypoint = entrypoint.GUID;
	    button.root.root.el_event.text = entrypoint.event.name + " / " + entrypoint.name;
	}

	dialog_destroy();
	dialog_destroy();


}
