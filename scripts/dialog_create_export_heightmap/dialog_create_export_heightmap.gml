/// @param Dialog

var dialog = argument0;

var dw = 400;
var dh = 320;

var dg = dialog_create(dw, dh, "Heightmap Settings", dialog_default, dc_close_no_questions_asked, dialog);

var columns = 1;
var ew = (dw - 64) / columns;
var eh = 24;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var el_scale = create_input(16, yy, "Heightmap scale:", ew, eh, null, "", "16", "1...255", validate_int, ui_value_real, 1, 255, 3, vx1, vy1, vx2, vy2, dg);
dg.el_scale = el_scale;

yy = yy + el_scale.height + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dmu_dialog_commit_preferences, dg);

ds_list_add(dg.contents,
    el_scale,
    el_confirm
);

return dg;