/// @param Dialog

var dialog = argument0;

var dw = 768;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Availalbe UI Graphics", dialog_default, dc_default, dialog);

var columns = 3;
var ew = (dw - 64) / columns;
var eh = 24;

var c2 = dw / columns;
var c3 = dw * 2 / columns;

var vx1 = 0;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var el_list = create_list(16, yy, "UI Graphics", "<no UI graphics>", ew, eh, 12, uivc_list_graphic_ui, false, dg, Stuff.all_graphic_ui);
el_list.entries_are = ListEntries.INSTANCES;
el_list.numbered = true;
dg.el_list = el_list;

var el_add = create_button(c2 + 16, yy, "Add Image", ew, eh, fa_center, dmu_dialog_load_graphic_ui, dg);
yy = yy + el_add.height + spacing;
var el_remove = create_button(c2 + 16, yy, "Remove Image", ew, eh, fa_center, dmu_dialog_remove_graphic_ui, dg);
yy = yy + el_remove.height + spacing;

var el_name_text = create_text(c2 + 16, yy, "Name:", ew, eh, fa_left, ew, dg);
yy = yy + el_name_text.height + spacing;
var el_name = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_ui_name, "", "", "", validate_string, ui_value_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name = el_name;
yy = yy + el_name.height + spacing;
var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
yy = yy + el_name_internal_text.height + spacing;
var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, uivc_input_graphic_ui_internal_name, "", "", "A-Za-z0-9_", validate_string_internal_name, ui_value_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name_internal = el_name_internal;
yy = yy + el_name_internal.height + spacing;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list,
    el_add, el_remove,
    el_name_text, el_name, el_name_internal_text, el_name_internal,
    el_confirm);

return dg;