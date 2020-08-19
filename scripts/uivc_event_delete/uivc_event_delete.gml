/// @param UIButton
function uivc_event_delete(argument0) {

    var button = argument0;
    var event = button.root.event;
    var index = ds_list_find_index(Stuff.all_events, event);

    ds_list_delete(Stuff.all_events, index);
    ui_list_deselect(button.root.root.el_event_list);
    instance_activate_object(event);
    instance_destroy(event);

    Stuff.event.active = Stuff.all_events[| 0];

    dc_default(button);


}
