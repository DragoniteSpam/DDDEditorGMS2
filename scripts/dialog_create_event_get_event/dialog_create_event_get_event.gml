/// @param root
/// @param node
/// @param index
/// @param multi-index
function dialog_create_event_get_event(argument0, argument1, argument2, argument3) {

    var root = argument0;
    var node = argument1;
    var index = argument2;
    var multi_index = argument3;

    var dw = 320;
    var dh = 640;

    var dg = dialog_create(dw, dh, "Select Event", dialog_default, dialog_destroy, root);
    dg.event = noone;
    dg.node = node;
    dg.index = index;
    dg.multi_index = multi_index;

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var yy = 64;

    var el_list = create_list(16, yy, "Select an event", "<how do you even have no events?>", ew, eh, 20, null, false, dg, Game.events.events);
    el_list.entries_are = ListEntries.INSTANCES;
    dg.el_list = el_list;

    var current = guid_get(dg.node.custom_data[dg.index][multi_index]);
    if (current) {
        ui_list_select(el_list, array_get_index(Game.events.events, current.event));
    }

    var b_width = 128;
    var b_height = 32;
    var el_remove = create_button(dw / 3 - b_width / 2 - spacing, dh - 32 - b_height / 2, "Clear", b_width, b_height, fa_center, dmu_create_event_event_entrypoint_remove, dg);
    var el_confirm = create_button(dw * 2 / 3 - b_width / 2 + spacing, dh - 32 - b_height / 2, "Next", b_width, b_height, fa_center, dmu_create_event_event_entrypoint_list, dg);

    ds_list_add(dg.contents,
        el_list,
        el_remove,
        el_confirm
    );

    return dg;


}
