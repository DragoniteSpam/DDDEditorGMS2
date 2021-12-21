/// @param UIButton
function uivc_event_delete(argument0) {

    var button = argument0;
    var event = button.root.event;
    var index = array_search(Game.events.events, event);

    array_delete(Game.events.events, index, 1);
    ui_list_deselect(button.root.root.el_event_list);

    Stuff.event.active = Game.events.events[0];

    event.Destroy();

    dialog_destroy();


}
