/// @description void omu_entity_event_page(UIThing);
/// @param UIThing

var catch=argument0;

if (ui_list_selection(Camera.ui.element_entity_events)>-1) {
    dialog_create_entity_event_page(noone);
}
