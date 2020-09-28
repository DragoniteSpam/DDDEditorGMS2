/// @description void uivc_entity_event_enable(UIThing);
/// @param UIThing
function uivc_entity_event_enable(argument0) {

    // safe
    var index=ui_list_selection(Stuff.map.ui.element_entity_events);
    var list=Stuff.map.selected_entities
    var entity=list[| 0];
    var page=entity.object_events[| index];

    page.enabled=argument0.value;



}
