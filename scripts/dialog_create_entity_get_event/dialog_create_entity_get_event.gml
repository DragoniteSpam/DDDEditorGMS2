/// @param Dialog
function dialog_create_entity_get_event(argument0) {

    var dialog = argument0;

    var dw = 400;
    var dh = 640;

    // you can assume that this is valid data because this won't be called otherwise
    var index = ui_list_selection(Stuff.map.ui.element_entity_events);
    var list = Stuff.map.selected_entities;
    var entity = list[| 0];

    var page = entity.object_events[index];
    var dg = dialog_create(dw, dh, "Select Event", dialog_default, dialog_destroy, dialog);

    var columns = 1;
    var spacing = 16;
    var ew = dw / columns - spacing * 2;
    var eh = 24;

    var vx1 = ew / 2;
    var vy1 = 0;
    var vx2 = ew;
    var vy2 = eh;

    var yy = 64;

    var el_list = create_list(16, yy, "Select an event", "<how do you even have no events?>", ew, eh, 20, null, false, dg, Stuff.all_events);
    el_list.entries_are = ListEntries.INSTANCES;
    dg.el_list = el_list;

    for (var i = 0; i < ds_list_size(Stuff.all_events); i++) {
        if (Stuff.all_events[| i].GUID == page.event_entrypoint) {
            ui_list_select(el_list, i);
            break;
        }
    }

    var b_width = 128;
    var b_height = 32;
    var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Select Node", b_width, b_height, fa_center, dmu_dialog_entity_get_event, dg);

    ds_list_add(dg.contents,
        el_list,
        el_confirm
    );

    return dg;


}
