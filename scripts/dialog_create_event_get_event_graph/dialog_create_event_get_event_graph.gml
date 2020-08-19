/// @param Dialog
/// @param node
/// @param index
function dialog_create_event_get_event_graph(argument0, argument1, argument2) {

    var dialog = argument0;
    var node = argument1;
    var index = argument2;

    var dw = 320;
    var dh = 640;

    var dg = dialog_create(dw, dh, "Select Event", dialog_default, dc_close_no_questions_asked, dialog);
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
    var outbound_label = (custom ? custom.outbound[| index] : "#" + string(index));
    var label = node.name + " / " + (string_length(outbound_label) > 0 ? outbound_label : "default");

    var el_title_text = create_text(16, yy, label, ew, eh, fa_left, ew, dg);

    yy += el_title_text.height + spacing;

    var el_list = create_list(16, yy, "Select an event", "<how do you even have no events?>", ew, eh, 18, null, false, dg, Stuff.all_events);
    el_list.entries_are = ListEntries.INSTANCES;
    dg.el_list = el_list;

    for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
        if (Stuff.all_events[| i] == Stuff.event.active) {
            ui_list_select(el_list, i);
            break;
        }
    }

    var b_width = 128;
    var b_height = 32;

    var el_clear = create_button(dw * 2 / 7 - b_width / 2, dh - 32 - b_height / 2, "Clear", b_width, b_height, fa_center, dmu_dialog_event_set_outbound_null, dg);
    el_clear.tooltip = "Set the outbound node to null; in the game, this will be the end of the event and control will return to the player";

    var el_confirm = create_button(dw * 5 / 7 - b_width / 2, dh - 32 - b_height / 2, "Select Node", b_width, b_height, fa_center, dialog_create_event_get_event_node, dg);
    el_confirm.tooltip = "Pick an entrypoint (or any other node) in the selected event for the node to continue to";

    ds_list_add(dg.contents,
        el_title_text,
        el_list,
        el_clear,
        el_confirm
    );

    return dg;


}
