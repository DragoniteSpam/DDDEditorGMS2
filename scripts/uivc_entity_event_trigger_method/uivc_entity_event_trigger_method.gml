/// @param UIList

var list = argument0;
var index = ui_list_selection(Camera.ui.element_entity_events);
var entity = Camera.selected_entities[| 0];
var page = entity.object_events[| index];

var flag = 0;

for (var i = 0; i < ds_list_size(Stuff.all_event_triggers); i++) {
	if (ds_map_exists(list.selected_entries, i)) {
		flag = flag | (1 << i);
	}
}

page.trigger = flag;