/// @param Dialog
/// @param name-string
/// @param default-value
/// @param onvaluechange
/// @param [instance]

var root = argument[0];
var name_string = argument[1];
var default_value = argument[2];
var onvaluechange = argument[3];
var instance = (argument_count > 4) ? argument[4] : noone;

var dw = 640;
var dh = 560;

var dg = dialog_create(dw, dh, "Flags: " + name_string, dialog_default, dc_close_no_questions_asked, root);
dg.instance = instance;

var columns = 2;
var spacing = 16;
var ew = (dw - spacing * 2) / columns;
var eh = 24;

var ew = (dw - columns * spacing * 2) / columns;
var eh = 24;

var c1 = dw * 0 / columns + spacing;
var c2 = dw * 1 / columns + spacing;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;

var color_active = c_ui_select;
var color_inactive = c_white;

var el_collision_flags = create_bitfield(c1, yy, "Miscellaneous Flags", ew, eh, onvaluechange, default_value, dg);

for (var i = 0; i < 32; i++) {
    var field_xx = (i >= 16) ? ew : 0;
    // Each element will be positioned based on the one directly above it, so you
    // only need to move them up once otherwise they'll keep moving up the screen
    var field_yy = (i == 16) ? -(eh * 16) : 0;
    var label = (i >= ds_list_size(Stuff.all_collision_triggers)) ? "<" + string(i) + ">" : Stuff.all_collision_triggers[| i];
    create_bitfield_options_vertical(el_collision_flags, [create_bitfield_option_data(i, ui_render_bitfield_option_text_generic_flag, uivc_bitfield_generic_flag, label, -1, 0, ew / 2, spacing / 2, field_xx, field_yy, color_active, color_inactive)]);
}

create_bitfield_options_vertical(el_collision_flags, [
    create_bitfield_option_data(i, ui_render_bitfield_option_text_generic_flag_all, uivc_bitfield_generic_flag_all, "All", -1, 0, ew / 2, spacing / 2, 0, 0, color_active, color_inactive),
    create_bitfield_option_data(i, ui_render_bitfield_option_text_generic_flag_none, uivc_bitfield_generic_flag_none, "None", -1, 0, ew / 2, spacing / 2, ew, -eh, color_active, color_inactive),
]);

el_collision_flags.tooltip = "Misc. flags which you may enable or disable. You can define flags in Global Game Settings.";

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, null, dg);

ds_list_add(dg.contents,
    el_collision_flags,
    el_confirm
);

return dg;