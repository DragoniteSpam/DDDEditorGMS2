/// @param UIThing
function uivc_entity_event_enable_variable_self(argument0) {

	var thing = argument0;

	// safe
	var index = ui_list_selection(Stuff.map.ui.element_entity_events);
	var list = Stuff.map.selected_entities
	var entity = list[| 0];
	var page = entity.object_events[| index];

	page.condition_variable_self_enabled = thing.value;


}
