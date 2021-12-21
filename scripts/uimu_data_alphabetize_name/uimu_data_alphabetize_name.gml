function uimu_data_alphabetize_name(thing) {
    var base_dialog = thing.root.root.root;
    
    var data = thing.root.data_type;
    var selection = ui_list_selection(base_dialog.el_instances);
    var instance = (selection + 1) ? data.instances[selection] : noone;
    
    if (data) {
        array_sort_name(data.instances);
        ui_list_deselect(base_dialog.el_instances);
        for (var i = 0; i < array_length(data.instances); i++) {
            if (data.instances[i] == instance) {
                ui_list_select(base_dialog.el_instances, i, true);
                break;
            }
        }
    }
    
    dialog_destroy();
}