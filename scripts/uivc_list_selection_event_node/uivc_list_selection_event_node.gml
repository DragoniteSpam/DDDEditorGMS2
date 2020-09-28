/// @param UIList
function uivc_list_selection_event_node(argument0) {

    var list = argument0;
    event_view_node(Stuff.event.active.nodes[| ui_list_selection(list)]);


}
