/// @param Dialog

var dialog = argument0;
var node = dialog.root.node;
var index = dialog.root.index;
var selection = ui_list_selection(dialog.root.el_list);
var event = Stuff.all_events[| selection];

if (event) {
    // you might think it's odd that this is of a different size than the get_event
    // dialog, except when they're the same size it's easy to not notice the contents
    // changing if there's not a lot of them, and to think that something went wrong
    var dw = 320;
    var dh = 640;
    
    var dg = dialog_create(dw, dh, event.name, dialog_default, dc_close_no_questions_asked, dialog);
    dg.node = node;
    dg.index = index;
    
    var columns = 1;
    var ew = (dw - columns * 32) / columns;
    var eh = 24;
    
    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = vy1 + eh;
    
    var yy = 64;
    var spacing = 16;
    
    var custom = guid_get(node.custom_guid);
    var outbound_label = (custom ? custom.outbound[| index] : "#" + string(index));
    var label = node.name + " / " + (string_length(outbound_label) > 0 ? outbound_label : "default");
    
    var el_title_text = create_text(16, yy, label, ew, eh, fa_left, ew, dg);
    
    yy = yy + el_title_text.height + spacing;
    
    var el_list = create_list(16, yy, "Select an entrypoint", "<should never see this>", ew, eh, 18, null, false, dg, event.nodes);
    for (var i = 0; i < ds_list_size(event.nodes); i++) {
        // this happens before the list is updated, so you don't need to bother with size minus 1
        if (node.outbound[| index] == event.nodes[| i]) {
            ui_list_select(el_list, i, true);
            break;
        }
    }
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.colorize = false;
    dg.el_list = el_list;
    
    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, null, dg);
    
    ds_list_add(dg.contents,
        el_title_text,
        el_list,
        el_confirm
    );
    
    return dg;
}

dialog_destroy();
return noone;