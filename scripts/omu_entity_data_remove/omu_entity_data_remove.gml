function omu_entity_data_remove(button) {
    var base_dialog = button.root;
    var entity = button.root.entity;
    var selection = ui_list_selection(base_dialog.el_list);

    if (array_length(entity.generic_data) > 0) {
        if (is_clamped(selection, 0, array_length(entity.generic_data) - 1)) {
            var data = entity.generic_data[selection];
            array_delete(entity.generic_data, selection, 1);
            instance_activate_object(data);
            instance_destroy(data);
        }
        
        ui_list_deselect(button.root.el_data_list);
        
        // enable by type whatever is currently selected; if the last entry in the
        // list has been deleted, then disable all of the needed buttons
        var last = array_length(entity.generic_data) - 1;
        dialog_entity_data_type_disable(base_dialog);
        
        if (array_length(entity.generic_data) == 0) {
            ui_list_deselect(base_dialog.el_list);
        } else {
            if (!is_clamped(selection, 0, last)) {
                ui_list_deselect(base_dialog.el_list);
                base_dialog.el_list.selected_entries[? last] = true;
            }
            dialog_entity_data_enable_by_type(base_dialog);
        }
    }
}