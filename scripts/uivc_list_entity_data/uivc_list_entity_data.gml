/// @param UIList
function uivc_list_entity_data(argument0) {

    var list = argument0;

    var selection = ui_list_selection(list);

    if (selection + 1) {
        var data = list.entries[| selection];
        dialog_entity_data_type_disable(list.root);
        dialog_entity_data_enable_by_type(list.root);
    }


}
