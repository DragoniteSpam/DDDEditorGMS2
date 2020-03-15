/// @param Dialog

var dw = 768;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Availalbe Sound Effects", dialog_default, dc_default, argument0);

var columns = 3;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var c2 = dw / columns;
var c3 = dw * 2 / columns;

var vx1 = 0;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_list = create_list(16, yy, "Sound Effects", "<no sound effects>", ew, eh, 12, uivc_list_audio_se, false, dg, Stuff.all_se);
el_list.entries_are = ListEntries.INSTANCES;
el_list.numbered = true;
dg.el_list = el_list;

var el_add = create_button(c2 + 16, yy, "Add SE", ew, eh, fa_center, dmu_dialog_load_se, dg);
yy += el_add.height + spacing;
var el_remove = create_button(c2 + 16, yy, "Remove SE", ew, eh, fa_center, dmu_dialog_remove_se, dg);
yy += el_remove.height + spacing;

var el_name_text = create_text(c2 + 16, yy, "Name:", ew, eh, fa_left, ew, dg);
yy += el_name_text.height + spacing;
var el_name = create_input(c2 + 16, yy, "", ew, eh, uivc_input_audio_se_name, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name = el_name;
yy += el_name.height + spacing;
var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
yy += el_name_internal_text.height + spacing;
var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, uivc_input_audio_se_rate, 0, "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name_internal = el_name_internal;
yy += el_name_internal.height + spacing;

var xx = c2 + 16;
var el_play = create_button(xx, yy, "Play", ew / 4, eh, fa_center, dmu_dialog_play_se, dg);
xx = xx + ((ew - 32) / 4);
var el_pause = create_button(xx, yy, "Pause", ew / 4, eh, fa_center, dmu_dialog_pause, dg);
xx = xx + ((ew - 32) / 4);
var el_resume = create_button(xx, yy, "Rsm.", ew / 4, eh, fa_center, dmu_dialog_resume, dg);
xx = xx + ((ew - 32) / 4);
var el_stop = create_button(xx, yy, "Stop", ew / 4, eh, fa_center, dmu_dialog_stop, dg);

yy += el_play.height + spacing * 2;
var el_effects = create_text(c2 + 16, yy, "Effects such as volume, pitch, etc can be defined when the sound is played in-game.", ew, eh, fa_left, ew, dg);
yy += el_effects.height + spacing * 2;

var vx1 = dw / (columns * 2) - 16;
var vy1 = 0;
var vx2 = vx1 + 80 + 32;
var vy2 = eh;

yy = yy_base;

var el_sample_rate = create_input(c3 + 16, yy, "Sample Rate:", ew, eh, uivc_input_audio_se_rate, 0, "hertz", validate_int, 0, 0xffffff, 8, vx1, vy1, vx2, vy2, dg);
dg.el_sample_rate = el_sample_rate;
yy += el_sample_rate.height + spacing;
var xx = c3 + 16;
var el_rate_441 = create_button(xx, yy, "44.1 KHz", ew / 2, eh, fa_center, dmu_input_audio_se_rate_441, dg);
xx = xx + ((ew - 32) / 2);
var el_rate_48 = create_button(xx, yy, "48 KHz", ew / 2, eh, fa_center, dmu_input_audio_se_rate_48, dg);
xx = xx + ((ew - 32) / 2);
yy += el_rate_441.height + spacing;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list, el_add, el_remove,
    el_play, el_pause, el_resume, el_stop,
    el_name_text, el_name, el_name_internal_text, el_name_internal, el_effects,
    el_sample_rate, el_rate_441, el_rate_48,
    el_confirm
);

return dg;