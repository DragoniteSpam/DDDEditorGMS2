/// @param Dialog

var dw = 512;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Availalbe Background Music", dialog_default, dc_default, argument0);

var ew = (dw - 64) / 2;
var eh = 24;

var c2 = dw / 2;

var vx1 = dw / 4 + 16 - 64;
var vy1 = 0;
var vx2 = vx1 + 80 + 64;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var spacing = 16;

var el_list = create_list(16, yy, "Background Music", "<no music>", ew, eh, 12, null, false, dg);
el_list.render = ui_render_list_bgm;
dg.el_list = el_list;

var el_add = create_button(c2 + 16, yy, "Add BGM", ew, eh, fa_center, dmu_dialog_load_bgm, dg);
yy = yy + el_add.height + spacing;
var el_remove = create_button(c2 + 16, yy, "Remove BGM", ew, eh, fa_center, dmu_dialog_remove_bgm, dg);
yy = yy + el_remove.height + spacing;

var el_name = create_input(c2 + 16, yy, "Name:", ew, eh, null, "", "", "A-Za-z0=9_", validate_string_internal_name, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
yy = yy + el_name.height + spacing;

var xx = c2 + 16;
var el_play = create_button(xx, yy, "Play", ew / 4, eh, fa_center, dmu_dialog_play_se, dg);
var xx = xx + ((c2 - 32) / 4);
var el_pause = create_button(xx, yy, "Pause", ew / 4, eh, fa_center, dmu_dialog_pause, dg);
var xx = xx + ((c2 - 32) / 4);
var el_resume = create_button(xx, yy, "Resume", ew / 4, eh, fa_center, dmu_dialog_resume, dg);
var xx = xx + ((c2 - 32) / 4);
var el_stop = create_button(xx, yy, "Stop", ew / 4, eh, fa_center, dmu_dialog_stop, dg);

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list,
    el_add, el_remove,
    el_play, el_pause, el_resume, el_stop,
    el_name,
    el_confirm);

keyboard_string = "";

return dg;