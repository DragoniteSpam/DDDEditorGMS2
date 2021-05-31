/// @param UIList
function uivc_refid_picker_event_node(argument0) {

    var list = argument0;
    var node = list.root.node;
    var index = list.root.index;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        node.custom_data[@ index][@ 0] = list.entries[| selection].REFID;
    } else {
        node.custom_data[@ index][@ 0] = 0;
    }


}
