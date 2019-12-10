/// @param Dialog

var dw = 320;
var dh = 640;

// todo cache the custom event and only commit the changes when you're done
var dg = dialog_create(dw, dh, "Prefab Nodes", dialog_default, dc_close_no_questions_asked, argument0);

var columns = 1;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var vx1 = dw / (columns * 2) - 16;
var vy1 = 0;
var vx2 = vx1 + dw / (columns * 2) - 16;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var spacing = 16;
var n_slots = 20;

var yy = 64;

var el_list = create_list(16, yy, "Prefab Nodes:", "<no prefab nodes>", ew, eh, n_slots, null, false, dg, Stuff.all_event_prefabs);
el_list.entries_are = ListEntries.INSTANCES;

dg.el_list_main = el_list;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, omu_event_add_prefab_event, dg);
dg.el_confirm = el_confirm;

ds_list_add(dg.contents,
    el_list,
    el_confirm,
);

return dg;