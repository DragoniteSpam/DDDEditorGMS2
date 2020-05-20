/// @param UIButton

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

dmu_dialog_commit(button);