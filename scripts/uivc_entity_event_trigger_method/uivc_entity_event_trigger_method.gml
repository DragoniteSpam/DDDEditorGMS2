/// @param UIList
function uivc_entity_event_trigger_method(argument0) {

    var list = argument0;
    var index = ui_list_selection(Stuff.map.ui.element_entity_events);
    var entity = Stuff.map.selected_entities[| 0];
    var page = entity.object_events[| index];

    var flag = 0;

    for (var i = 0; i < ds_list_size(Stuff.all_event_triggers); i++) {
        if (ui_list_is_selected(list, i)) {
            flag = flag | (1 << i);
        }
    }

    page.trigger = flag;


}
