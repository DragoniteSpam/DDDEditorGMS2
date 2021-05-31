/// @param Dialog
/// @param DataEvent
function dialog_create_event_get_event_entrypoint(argument0, argument1) {

    var dialog = argument0;
    var event = argument1;

    // you might think it's odd that this is of a different size than the get_event
    // dialog, except when they're the same size it's easy to not notice the contents
    // changing if there's not a lot of them, and to think that something went wrong
    var dw = 320;
    var dh = 544;

    var dg = dialog_create(dw, dh, "Select entrypoint", dialog_default, dialog_destroy, dialog);
    dg.event = event;
    dg.node = dialog.root.node;
    dg.index = dialog.root.index;
    dg.multi_index = dialog.root.multi_index;

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var yy = 64;

    var el_list = create_list(16, yy, "Entrypoints", "<event has no entrypoints>", ew, eh, 16, null, false, dg);
    el_list.entries_are = ListEntries.INSTANCES;
    el_list.colorize = false;
    dg.el_list = el_list;

    var current_index = -1;
    var en = 0;
    var data = dg.node.custom_data[dg.index];
    for (var i = 0; i < ds_list_size(dg.event.nodes); i++) {
        var node = dg.event.nodes[| i];
        if (node.type == EventNodeTypes.ENTRYPOINT) {
            if (node.GUID == data[dg.multi_index]) {
                current_index = en;
            }
            ds_list_add(el_list.entries, node);
            en++;
        }
    }

    if (current_index + 1) {
        // can't do this and set the position in the above loop directly because the list
        // isn't finished being populated yet
        ui_list_select(el_list, current_index, true);
    }

    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Select", b_width, b_height, fa_center, dmu_create_event_event_entrypoint_finalize, dg);

    ds_list_add(dg.contents,
        el_list,
        el_confirm
    );

    return dg;


}
