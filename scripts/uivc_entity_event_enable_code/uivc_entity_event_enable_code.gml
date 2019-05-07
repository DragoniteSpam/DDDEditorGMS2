/// @description  void uivc_entity_event_enable_code(UIThing);
/// @param UIThing

// safe
var index=ui_list_selection(Camera.ui.element_entity_events);
var list=Camera.selected_entities
var entity=list[| 0];
var page=entity.object_events[| index];

page.condition_code_enabled=argument0.value;
