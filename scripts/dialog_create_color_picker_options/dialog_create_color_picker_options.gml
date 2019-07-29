/// @param Dialog
/// @param default-color

var dialog = argument0;
var color = argument1;

var dw = 320;
var dh = 320;

var dg = dialog_create(dw, dh, "Pick a color", dialog_default, dc_close_no_questions_asked, dialog);

var ew = dw - 64;
var eh = 24;

var vx1 = 120;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;

var el_picker = create_color_picker_input(32, yy, ew, eh, null, 0, color, true, vx1, vy1, vx2, vy2, dg);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Good", b_width, b_height, fa_center, dmu_dialog_commit_preferences, dg);

ds_list_add(dg.contents, el_picker,
    el_confirm);

return dg;