/// @param UIList
function uivc_list_selection_event(argument0) {

    var list = argument0;

    Stuff.event.active = Stuff.all_events[| ui_list_selection(list)];


}
