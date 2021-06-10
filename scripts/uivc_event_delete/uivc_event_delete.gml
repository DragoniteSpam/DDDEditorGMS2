/// @param UIButton
function uivc_event_delete(argument0) {

    var button = argument0;
    var event = button.root.event;
    var index = ds_list_find_index(Game.events.events, event);

    ds_list_delete(Game.events.events, index);
    ui_list_deselect(button.root.root.el_event_list);
    instance_activate_object(event);
    instance_destroy(event);

    Stuff.event.active = Game.events.events[| 0];

    dialog_destroy(button);


}
