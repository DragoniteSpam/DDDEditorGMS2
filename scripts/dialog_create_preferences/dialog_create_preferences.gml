/// @param Dialog

var dialog = argument0;

var dw = 512;
var dh = 640;

var dg = dialog_create(dw, dh, "Preferences", dialog_default, dc_close_no_questions_asked, dialog);

var ew = (dw - 64) / 2;
var eh = 24;

var c2 = dw / 2;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var el_bezier = create_input(16, yy, "Bezier precision:", ew, eh, uivc_bezier_precision, Stuff.setting_bezier_precision, "0...9", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
yy = yy + el_bezier.height + spacing;
var el_tooltips = create_checkbox(16, yy, "Show Tooltips", ew, eh, uivc_show_tooltips, Stuff.setting_tooltip, dg);
el_tooltips.tooltip = "These things";
yy = yy + el_tooltips.height + spacing;
var el_backups = create_input(16, yy, "Backups: ", ew, eh, uivc_backups, Stuff.setting_backups, "0...9", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
yy = yy + el_backups.height + spacing;
var el_autosave = create_checkbox(16, yy, "Automatic Backups", ew, eh, uivc_autosave, Stuff.setting_autosave, dg);
yy = yy + el_autosave.height + spacing;
var el_npc_animation = create_input(16, yy, "NPC speed:", ew, eh, uivc_bezier_precision, Stuff.setting_npc_animate_rate, "0...9", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
yy = yy + el_npc_animation.height + spacing;
var el_ui_color = create_color_picker(16, yy, "UI Color:", ew, eh, uivc_ui_color, Stuff.setting_color, vx1, vy1, vx2, vy2, dg);
yy = yy + el_ui_color.height + spacing;

yy = yy_base;

var el_code_ext_text = create_text(c2 + 16, yy, "This only really affects the text editor you want to be able to edit Lua code with. " +
    "Plain text files will open with Notepad by default, but if you have another editor set you can use that instead.", ew, eh * 8, fa_left, ew, dg);
yy = yy + eh * 7 + spacing;
var el_code_ext = create_radio_array(c2 + 16, yy, "Code File Extension:", ew, eh, uivc_code_extension, Stuff.setting_code_extension, dg);
create_radio_array_options(el_code_ext, ["*.txt", "*.lua"]);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Commit", b_width, b_height, fa_center, dmu_dialog_commit_preferences, dg);

ds_list_add(dg.contents,
    el_bezier, el_tooltips, el_backups, el_autosave, el_npc_animation, el_ui_color,
    el_code_ext_text, el_code_ext,
    el_confirm
);

return dg;