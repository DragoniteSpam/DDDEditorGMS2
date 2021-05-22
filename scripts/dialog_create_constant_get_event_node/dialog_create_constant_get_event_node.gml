function dialog_create_constant_get_event_node(dialog) {
    var selection = ui_list_selection(dialog.root.el_list);
    var constant = dialog.root.constant;
    var event = Stuff.all_events[| ui_list_selection(dialog.root.el_list)];
    
    if (!event) {
        return noone;
    }
    
    // you might think it's odd that this is of a different size than the get_event
    // dialog, except when they're the same size it's easy to not notice the contents
    // changing if there's not a lot of them, and to think that something went wrong
    var dw = 320;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, event.name, dialog_default, dialog_destroy, dialog);
    dg.constant = constant;
    dg.event = event;
    
    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;
    
    var yy = 64;
    
    var el_title_text = create_text(16, yy, constant.name, ew, eh, fa_left, ew, dg);
    yy += el_title_text.height + spacing;
    
    var el_list = create_list(16, yy, "Select an entrypoint", "<no entrypoints>", ew, eh, 18, null, false, dg);
    for (var i = 0; i < ds_list_size(event.nodes); i++) {
        if (event.nodes[| i].type == EventNodeTypes.ENTRYPOINT) {
            ds_list_add(el_list.entries, event.nodes[| i]);
        }
    }
    ui_list_select(el_list, ds_list_find_index(el_list.entries, guid_get(constant.value_guid)));
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.colorize = false;
    dg.el_list = el_list;
    
    var b_width = 128;
    var b_height = 32;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Select", b_width, b_height, fa_center, function(button) {
        var selection = ui_list_selection(button.root.el_list);
        var event = button.root.event;
        var constant = button.root.constant;
        var entrypoint = button.root.el_list.entries[| selection];
        
        if (entrypoint) {
            constant.value_guid = entrypoint.GUID;
            var constant_dialog = button.root.root.root.root;
            constant_dialog.el_event.text = "Event: " + event.name;
            constant_dialog.el_event_entrypoint.text = "Entrypoint: " + entrypoint.name;
            dialog_destroy();
            dialog_destroy();
        }
    }, dg);
    
    el_confirm.tooltip = "Set the value to the selected entrypoint";
    
    ds_list_add(dg.contents,
        el_title_text,
        el_list,
        el_confirm
    );
    
    return dg;
}