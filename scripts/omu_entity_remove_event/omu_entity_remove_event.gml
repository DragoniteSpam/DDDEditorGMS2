/// @param UIButton
function omu_entity_remove_event(argument0) {

	var button = argument0;
	var list = Stuff.map.selected_entities;

	if (!ds_list_empty(list)) {
	    var index = ui_list_selection(Stuff.map.ui.element_entity_events);
    
	    if (index + 1) {
	        dialog_create_entity_remove_event_page(list[| 0], index, button.root);
	    }
	}


}
