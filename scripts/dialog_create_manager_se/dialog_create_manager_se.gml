/// @param Dialog

var dw = 512;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Availalbe Sound Effects", dialog_default, dc_default, argument0);

var ew = (dw - 64) / 2;
var eh = 24;

var c2 = dw / 2;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var spacing = 16;

var el_list = create_list(16, yy, "Sound Effects", "<no sound effects>", ew, eh, 12, null, false, dg);
el_list.render = ui_render_list_se;

var el_add = create_button(c2 + 16, yy, "Add SE", ew, eh, fa_center, dmu_dialog_load_se, dg);
yy = yy + el_add.height + spacing;
var el_rename = create_button(c2 + 16, yy, "Rename SE", ew, eh, fa_center, null, dg);
yy = yy + el_rename.height + spacing;
var el_remove = create_button(c2 + 16, yy, "Remove SE", ew, eh, fa_center, null, dg);
yy = yy + el_remove.height + spacing;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list,
    el_add, el_rename, el_remove,
    el_confirm);

keyboard_string = "";

return dg;