/// @param UIButton

var button = argument0;

// no need to validate this - [0] is automatically selected when
// the list is created
var selection_index = ui_list_selection(button.root.el_list);
var entrypoint_guid = button.root.el_list.entries[| selection_index];

// safe
var index = ui_list_selection(Stuff.map.ui.element_entity_events);
var list = Stuff.map.selected_entities;
var entity = list[| 0];
var page = entity.object_events[| index];
var event = guid_get(page.event_guid);

page.event_entrypoint = entrypoint_guid;
button.root.root.el_event_entrypoint.text = "Entrypoint: " + guid_get(entrypoint_guid).name;

dmu_dialog_commit(button);