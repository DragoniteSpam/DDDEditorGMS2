function dmu_dialog_event_set_outbound(button) {
    var destroy_dialogs = true;
    
    var selection = ui_list_selection(button.root.el_list);
    var destination = button.root.el_list.entries[| selection];
    
    if (destination) {
        var node = button.root.node;
        var index = button.root.index;
        
        if (destination == node) {
            emu_dialog_notice("Please don't set a node's outbound node to itself! That would produce an infinite loop!");
            destroy_dialogs = false;
        } else {
            node.Connect(destination, index);
        }
    }
    
    if (destroy_dialogs) {
        dialog_destroy();
        dialog_destroy();
    }
}