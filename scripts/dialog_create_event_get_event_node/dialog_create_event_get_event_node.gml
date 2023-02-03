/// @param Dialog
function dialog_create_event_get_event_node(argument0) {

    var dialog = argument0;
    var node = dialog.root.node;
    var index = dialog.root.index;
    var selection = ui_list_selection(dialog.root.el_list);
    var event = Game.events.events[selection];

    if (event) {
        // you might think it's odd that this is of a different size than the get_event
        // dialog, except when they're the same size it's easy to not notice the contents
        // changing if there's not a lot of them, and to think that something went wrong
        var dw = 320;
        var dh = 640;
    
        var dg = dialog_create(dw, dh, event.name, dialog_default, dialog_destroy, dialog);
        dg.node = node;
        dg.index = index;
    
        var columns = 1;
        var spacing = 16;
        var ew = dw / columns - spacing * 2;
        var eh = 24;
    
        var vx1 = ew / 2;
        var vy1 = 0;
        var vx2 = ew;
        var vy2 = eh;
    
        var yy = 64;
    
        var custom = guid_get(node.custom_guid);
        var outbound_label = (custom ? custom.outbound[index] : "#" + string(index));
        var label = node.name + " / " + (string_length(outbound_label) > 0 ? outbound_label : "default");
    
        var el_title_text = create_text(16, yy, label, ew, eh, fa_left, ew, dg);
    
        yy += el_title_text.height + spacing;
    
        var el_list = create_list(16, yy, "Select an entrypoint", "<no entrypoints>", ew, eh, 18, null, false, dg);
        for (var i = 0; i < array_length(event.nodes); i++) {
            if (node.event == event || event.nodes[i].type == EventNodeTypes.ENTRYPOINT) {
                ds_list_add(el_list.entries, event.nodes[i]);
            }
        }
        ui_list_select(el_list, array_get_index(event.nodes, node.outbound[index]));
        el_list.entries_are = ListEntries.INSTANCES;
        el_list.colorize = false;
        dg.el_list = el_list;
    
        var b_width = 128;
        var b_height = 32;
    
        var el_clear = create_button(dw * 2 / 7 - b_width / 2, dh - 32 - b_height / 2, "Clear", b_width, b_height, fa_center, function(button) {
            button.root.node.Connect(undefined, button.root.index, true);
            dialog_destroy();
            dialog_destroy();
        }, dg);
        el_clear.tooltip = "Set the outbound node to null; in the game, this will be the end of the event and control will return to the player";
    
        var el_confirm = create_button(dw * 5 / 7 - b_width / 2, dh - 32 - b_height / 2, "Select", b_width, b_height, fa_center, dmu_dialog_event_set_outbound, dg);
        el_confirm.tooltip = "Set the outbound node to the selected entry in the list";
    
        ds_list_add(dg.contents,
            el_title_text,
            el_list,
            el_clear,
            el_confirm
        );
    
        return dg;
    }

    dialog_destroy();
    return noone;


}
