/// @param UIList
function uivc_list_event_attain_variable_index(argument0) {

    var list = argument0;

    var data = list.root.node.custom_data[| 0];
    data[| 0] = ui_list_selection(list);


}
