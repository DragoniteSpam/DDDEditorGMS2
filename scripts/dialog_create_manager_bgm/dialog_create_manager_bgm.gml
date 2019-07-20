/// @param Dialog

var dialog = argument0;

var dw = 768;
var dh = 480;

var dg = dialog_create(dw, dh, "Data: Availalbe Background Music", dialog_default, dc_default, dialog);

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

var el_list = create_list(16, yy, "Background Music", "<no music>", ew, eh, 12, uivc_list_audio_bgm, false, dg);
el_list.render = ui_render_list_bgm;
el_list.entries_are = ListEntries.INSTANCES;
el_list.numbered = true;
dg.el_list = el_list;

var el_add = create_button(c2 + 16, yy, "Add BGM", ew, eh, fa_center, dmu_dialog_load_bgm, dg);
yy = yy + el_add.height + spacing;
var el_remove = create_button(c2 + 16, yy, "Remove BGM", ew, eh, fa_center, dmu_dialog_remove_bgm, dg);
yy = yy + el_remove.height + spacing;

var el_name_text = create_text(c2 + 16, yy, "Name:", ew, eh, fa_left, ew, dg);
yy = yy + el_name_text.height + spacing;
var el_name = create_input(c2 + 16, yy, "", ew, eh, uivc_input_audio_bgm_name, "", "", "", validate_string, ui_value_string, 0, 1, 20, vx1, vy1, vx2, vy2, dg);
dg.el_name = el_name;
yy = yy + el_name.height + spacing;
var el_name_internal_text = create_text(c2 + 16, yy, "Internal Name:", ew, eh, fa_left, ew, dg);
yy = yy + el_name_internal_text.height + spacing;
var el_name_internal = create_input(c2 + 16, yy, "", ew, eh, uivc_input_audio_bgm_internal_name, "", "", "A-Za-z0-9_", validate_string_internal_name, ui_value_string, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name_internal = el_name_internal;
yy = yy + el_name_internal.height + spacing;

var xx = c2 + 16;
var el_play = create_button(xx, yy, "Play", ew / 4, eh, fa_center, dmu_dialog_play_bgm, dg);
var xx = xx + ((c2 - 32) / 4);
var el_pause = create_button(xx, yy, "Pause", ew / 4, eh, fa_center, dmu_dialog_pause, dg);
var xx = xx + ((c2 - 32) / 4);
var el_resume = create_button(xx, yy, "Rsm.", ew / 4, eh, fa_center, dmu_dialog_resume, dg);
var xx = xx + ((c2 - 32) / 4);
var el_stop = create_button(xx, yy, "Stop", ew / 4, eh, fa_center, dmu_dialog_stop, dg);
yy = yy + el_name.height + spacing * 2;

var el_effects = create_text(c2 + 16, yy, "Effects such as volume, pitch, etc can be defined when the sound is played in-game.", ew, eh, fa_left, ew, dg);
yy = yy + el_effects.height + spacing * 2;

var vx1 = dw / (columns * 2) - 16;
var vy1 = 0;
var vx2 = vx1 + 80 + 32;
var vy2 = vy1 + eh;

yy = yy_base;
var el_length = create_text(c3 + 16, yy, "Length: N/A", ew, eh, fa_left, ew, dg);
dg.el_length = el_length;
yy = yy + el_length.height + spacing;
var el_loop_start = create_input(c3 + 16, yy, "Loop Start:", ew, eh, uivc_input_audio_loop_start, "", 0, "seconds", validate_double, ui_value_real, 0, 10000, 5, vx1, vy1, vx2, vy2, dg);
dg.el_loop_start = el_loop_start;
yy = yy + el_loop_start.height + spacing;
var el_loop_end = create_input(c3 + 16, yy, "Loop End:", ew, eh, uivc_input_audio_loop_end, "", 0, "seconds", validate_double, ui_value_real, 0, 10000, 5, vx1, vy1, vx2, vy2, dg);
dg.el_loop_end = el_loop_end;
yy = yy + el_loop_end.height + spacing;
var el_loop_progress = create_progress_bar(c3 + 16, yy, ew, eh, uivc_audio_bgm_loop_point, 8, 0, dg);
el_loop_progress.render = ui_render_progress_bgm;
el_loop_progress.color = merge_colour(c_blue, c_aqua, 0.4);
yy = yy + el_loop_progress.height + spacing;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list,
    el_add, el_remove,
    el_play, el_pause, el_resume, el_stop,
    el_name_text, el_name, el_name_internal_text, el_name_internal,
    el_effects, el_length, el_loop_start, el_loop_end, el_loop_progress,
    el_confirm);

keyboard_string = "";

return dg;