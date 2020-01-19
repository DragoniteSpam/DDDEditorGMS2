/// @param Dialog

var dialog = argument0;

var dw = 512;
var dh = 640;

var dg = dialog_create(dw, dh, "Preferences", dialog_default, dc_close_no_questions_asked, dialog);

var ew = (dw - 64) / 2;
var eh = 24;

var col1_x = 16;
var col2_x = dw / 2 + 16;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + 80;
var vy2 = vy1 + eh;

var yy = 64;
var yy_base = yy;
var spacing = 16;

var el_bezier = create_input(col1_x, yy, "Bezier precision:", ew, eh, uivc_bezier_precision, Stuff.setting_bezier_precision, "0...16", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
el_bezier.tooltip = "Higher-precision bezier curves look better, but take more computing power to draw. Lowering this will not fix performance issues, but it may help.";
yy = yy + el_bezier.height + spacing;

var el_tooltips = create_checkbox(col1_x, yy, "Show Tooltips", ew, eh, uivc_show_tooltips, Stuff.setting_tooltip, dg);
el_tooltips.tooltip = "These thingies.";
yy = yy + el_tooltips.height + spacing;

var el_npc_animation = create_input(col1_x, yy, "NPC speed:", ew, eh, uivc_bezier_precision, Stuff.setting_npc_animate_rate, "0...9", validate_int, 1, 16, 2, vx1, vy1, vx2, vy2, dg);
el_npc_animation.tooltip = "The speed at which NPC (Pawn) entities will animate.";
yy = yy + el_npc_animation.height + spacing;

var el_ui_color = create_color_picker(col1_x, yy, "UI Color:", ew, eh, uivc_ui_color, Stuff.setting_color, vx1, vy1, vx2, vy2, dg);
el_ui_color.tooltip = "The default color of the UI. I like green but you can make it something else if you don't like green.";
yy = yy + el_ui_color.height + spacing;

var el_camera_fly_text = create_text(col1_x, yy, "Camera Acceleration", ew, eh, fa_left, ew, dg);
yy = yy + el_camera_fly_text.height + spacing;

var el_camera_fly = create_progress_bar(col1_x, yy, ew, eh, uivc_camera_fly_rate, 4, normalize_correct(Stuff.setting_camera_fly_rate, 0, 1, 0.5, 4), dg);
el_camera_fly.tooltip = "How fast the camera accelerates in editor modes that use it (2D and 3D).";
yy = yy + el_camera_fly.height + spacing;

var el_alt_middle = create_checkbox(col1_x, yy, "Alternate Middle Click", ew, eh, uivc_settings_alt_middle, Stuff.setting_alternate_middle, dg);
el_alt_middle.tooltip = "My mouse is slightly broken and middle click doesn't always work, so I need an alternate method to use it. This is turned off by default so that it's harder to accidentally invoke, but you may turn it on if you need it.\n\n(The alternate input is Control + Space.)";
yy = yy + el_alt_middle.height + spacing;

yy = yy_base;

var el_code_ext = create_radio_array(col2_x + col1_x, yy, "Code File Extension:", ew, eh, uivc_code_extension, Stuff.setting_code_extension, dg);
el_code_ext.tooltip = "This only really affects the text editor you want to be able to edit Lua code with. Plain text files will open with Notepad by default, but if you have another editor set such as Notepad++ you can use that instead.";
create_radio_array_options(el_code_ext, ["*.txt", "*.lua"]);

yy = yy + ui_get_radio_array_height(el_code_ext) + spacing;

var el_text_ext = create_radio_array(col2_x + col1_x, yy, "Text File Extension:", ew, eh, uivc_text_extension, Stuff.setting_text_extension, dg);
el_text_ext.tooltip = "This only really affects the text editor you want to be able to edit text files with. Plain text files will open with Notepad by default, but if you have another editor set such as Notepad++ you can use that instead.";
create_radio_array_options(el_text_ext, ["*.txt", "*.md"]);

yy = yy + ui_get_radio_array_height(el_text_ext) + spacing;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_bezier,
    el_tooltips,
    el_npc_animation,
    el_ui_color,
    el_camera_fly_text,
    el_camera_fly,
    el_alt_middle,
    el_code_ext,
    el_text_ext,
    el_confirm
);

return dg;