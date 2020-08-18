/// @param UIThing
function omu_entity_event_page(argument0) {

	var thing = argument0;

	if (ui_list_selection(Stuff.map.ui.element_entity_events) > -1) {
	    dialog_create_entity_event_page(noone);
	}


}
