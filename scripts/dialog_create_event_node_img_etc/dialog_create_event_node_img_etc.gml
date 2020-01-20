/// @param Dialog
/// @param DataNode
/// @param property-index
/// @param multi-index

var dw = 320;
var dh = 640;

var dg = dialog_create(dw, dh, "Misc. Graphics", dialog_default, dc_close_no_questions_asked, argument0);

var columns = 1;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var b_width = 128;
var b_height = 32;

var spacing = 16;
var n_slots = 20;

var yy = 64;

var el_list = create_list(16, yy, "All Misc. Graphics", "<no misc graphics>", ew, eh, n_slots, null, false, dg, Stuff.all_graphic_etc);
el_list.entries_are = ListEntries.INSTANCES;
el_list.node = argument1;
el_list.property_index = argument2;
el_list.multi_index = argument3;

dg.el_list_main = el_list;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_custom_event_set_img_misc, dg);
dg.el_confirm = el_confirm;

ds_list_add(dg.contents,
    el_list,
    el_confirm
);

return dg;