/// @description  void dialog_create_preferences(Dialog);
/// @param Dialog

var dw=512;
var dh=320;

var dg=dialog_create(dw, dh, "Preferences", dialog_default, dc_close_no_questions_asked, argument0);

var ew=(dw-64)/2;
var eh=24;

var vx1=dw/4+16;
var vy1=0;
var vx2=vx1+80;
var vy2=vy1+eh;

var yy=64;
var spacing=16;

var el_bezier=create_input(16, yy, "Bezier precision:", ew, eh, uivc_bezier_precision, "", Stuff.setting_bezier_precision, "0...9",
    validate_int, ui_value_real, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
yy=yy+eh+spacing;
var el_backups=create_input(16, yy, "Backups: ", ew, eh, uivc_backups, "", Stuff.setting_backups, "0...9",
    validate_int, ui_value_real, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
yy=yy+eh+spacing;
var el_autosave=create_checkbox(16, yy, "Automatic Backups", ew, eh, uivc_autosave, "", Stuff.setting_autosave, dg);
yy=yy+eh+spacing;
var el_alphabet=create_checkbox(16, yy, "Alphabetize Lists", ew, eh, uivc_alphabetize_lists, "", Stuff.setting_alphabetize_lists, dg);
yy=yy+eh+spacing;
var el_npc_animation=create_input(16, yy, "NPC speed:", ew, eh, uivc_bezier_precision, "", Stuff.setting_alphabetize_npc_animate_rate, "0...9",
    validate_int, ui_value_real, 1, 16, 2, vx1, vy1, vx2, vy2, dg);

var b_width=128;
var b_height=32;
var el_confirm=create_button(dw/2-b_width/2, dh-32-b_height/2, "Commit", b_width, b_height, fa_center, dmu_dialog_commit_preferences, dg);

ds_list_add(dg.contents, el_bezier, el_backups, el_autosave, el_alphabet, el_npc_animation,
    el_confirm);

keyboard_string="";

return dg;
