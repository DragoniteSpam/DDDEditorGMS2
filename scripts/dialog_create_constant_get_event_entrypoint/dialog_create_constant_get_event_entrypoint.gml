function dialog_create_constant_get_event_entrypoint(dialog, constant) {
    // this is for when you select the Entrypoint button directly, instead of
    // finding it through the Event button
    var entrypoint = guid_get(constant.value_guid);
    var event = entrypoint ? entrypoint.event : noone;
    
    if (!event) {
        return dialog_create_constant_get_event_graph(dialog, constant);
    }
    
    var dw = 320;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, "Select entrypoint for: " + constant.name, dialog_default, dc_close_no_questions_asked, dialog);
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
    
    var el_list = create_list(16, yy, "Select an entrypoint", "<no entrypoints>", ew, eh, 16, null, false, dg);
    for (var i = 0; i < ds_list_size(event.nodes); i++) {
        if (event.nodes[| i].type == EventNodeTypes.ENTRYPOINT) {
            // this happens before the list is updated, so you don't need to bother with size minus 1
            if (entrypoint == event.nodes[| i]) {
                ui_list_select(el_list, ds_list_size(el_list.entries), true);
            }
            ds_list_add(el_list.entries, event.nodes[| i]);
        }
    }
    
    el_list.entries_are = ListEntries.INSTANCES;
    dg.el_list = el_list;
    
    var b_width = 128;
    var b_height = 32;
    
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Select Entrypoint", b_width, b_height, fa_center, function(button) {
        var selection = ui_list_selection(button.root.el_list);
        var event = button.root.event;
        var constant = button.root.constant;
        var entrypoint = button.root.el_list.entries[| selection];
        if (entrypoint) {
            constant.value_guid = entrypoint.GUID;
            var constant_dialog = button.root.root;
            constant_dialog.el_event.text = "Event: " + event.name;
            constant_dialog.el_event_entrypoint.text = "Entrypoint: " + entrypoint.name;
            dialog_destroy();
        }
    }, dg);
    el_confirm.tooltip = "Pick an entrypoint for the event";
    
    ds_list_add(dg.contents,
        el_title_text,
        el_list,
        el_confirm
    );
    
    return dg;
}