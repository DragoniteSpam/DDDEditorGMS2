/// @param UIButton

var button = argument0;

var selection = ui_list_selection(button.root.el_list);
var entrypoint = button.root.el_list.entries[| selection];

if (entrypoint) {
    var index = ui_list_selection(Stuff.map.ui.element_entity_events);
    var list = Stuff.map.selected_entities;
    var entity = list[| 0];
    var page = entity.object_events[| index];
    var event = guid_get(page.event_guid);
    
    page.event_entrypoint = entrypoint.GUID;
    button.root.root.el_event_entrypoint.text = "Entrypoint: " + entrypoint.name;
}

dmu_dialog_commit(button);