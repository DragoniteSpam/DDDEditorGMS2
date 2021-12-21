/// @param UIButton
function uivc_entity_remove_event_page(argument0) {

    var button = argument0;
    var entity = button.root.entity;
    var index = button.root.index;

    var event = entity.object_events[index];
    array_delete(entity.object_events, index, 1);
    ui_list_deselect(Stuff.map.ui.element_entity_events);

    dialog_destroy();


}
