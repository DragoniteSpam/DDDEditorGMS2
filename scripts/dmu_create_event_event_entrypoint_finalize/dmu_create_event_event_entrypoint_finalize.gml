function dmu_create_event_event_entrypoint_finalize(button) {
    var selection = ui_list_selection(button.root.el_list);
    if (selection + 1) {
        var entrypoint = button.root.el_list.entries[| selection];
        button.root.node.custom_data[button.root.index][button.root.multi_index] = entrypoint.GUID;
    }
    
    dmu_dialog_commit(button);
    dmu_dialog_commit(button);
}