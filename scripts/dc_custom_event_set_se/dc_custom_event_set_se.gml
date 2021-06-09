/// @param UIButton
function dc_custom_event_set_se(argument0) {

    var list = argument0.root.el_list_main;
    var selection = ui_list_selection(list);

    if (selection + 1) {
        list.node.custom_data[@ list.property_index][@ list.multi_index] = Stuff.all_se[selection].GUID;
    }

    dialog_destroy();


}
