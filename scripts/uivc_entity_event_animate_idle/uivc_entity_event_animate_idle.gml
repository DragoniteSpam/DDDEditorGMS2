/// @description void uivc_entity_event_animate_idle(UIThing);
/// @param UIThing

// safe
var index=ui_list_selection(Camera.ui.element_entity_events);
var list=Camera.selected_entities
var entity=list[| 0];
var page=entity.object_events[| index];

page.option_animate_idle=argument0.value;
