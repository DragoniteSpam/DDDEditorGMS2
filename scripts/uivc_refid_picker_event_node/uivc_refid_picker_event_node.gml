function uivc_refid_picker_event_node(element) {
    var node = element.root.node;
    var index = element.root.index;
    var type = element.root.el_type.value;
    
    switch (type) {
        case 0:
            node.custom_data[@ index][@ 0] = REFID_PLAYER;
            break;
        case 1:
            node.custom_data[@ index][@ 0] = REFID_SELF;
            break;
        case 2:
            var selection = ui_list_selection(element.root.el_list);
            if (selection + 1) {
                node.custom_data[@ index][@ 0] = element.root.el_list.entries[| selection].REFID;
            } else {
                node.custom_data[@ index][@ 0] = REFID_SELF;
            }
            break;
    }
    
    dmu_dialog_commit(element);
}