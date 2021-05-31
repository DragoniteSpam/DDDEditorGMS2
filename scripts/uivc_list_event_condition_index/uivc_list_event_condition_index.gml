/// @param UIList
function uivc_list_event_condition_index(argument0) {

    var list = argument0;

    list.root.node.custom_data[1][list.root.index] = ui_list_selection(list);


}
