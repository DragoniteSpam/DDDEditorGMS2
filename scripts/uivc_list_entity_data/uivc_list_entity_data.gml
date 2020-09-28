function uivc_list_entity_data(list) {
    var selection = ui_list_selection(list);
    
    if (selection + 1) {
        var data = list.entries[| selection];
        ui_list_deselect(list.root.el_data_list);
        dialog_entity_data_type_disable(list.root);
        dialog_entity_data_enable_by_type(list.root);
    }
}