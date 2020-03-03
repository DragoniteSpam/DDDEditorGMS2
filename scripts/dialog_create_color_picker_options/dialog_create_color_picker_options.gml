/// @param Dialog
/// @param default-color
/// @param [on-value-change]

var dialog = argument[0];
var color = argument[1];
var onvaluechange = (argument_count > 2) ? argument[2] : null;

var dw = 480;
var dh = 400;

var dg = dialog_create(dw, dh, "Pick a color", dialog_default, dc_close_no_questions_asked, dialog);

var ew = 320 - 64;
var eh = 24;

var vx1 = 120;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;

dg.el_picker = create_color_picker_input(32, yy, ew, eh, onvaluechange, color, false, vx1, vy1, vx2, vy2, dg);
dg.el_picker.axis_value = (color & 0x0000ff) / 0xff;
dg.el_picker.axis_w = ((color & 0x00ff00) >> 8) / 0xff;
dg.el_picker.axis_h = ((color & 0xff0000) >> 16) / 0xff;
dg.el_channels = create_radio_array(320, yy, "Axis Channel", ew / 2, eh, uivc_radio_color_picker_channel, 0, dg);
create_radio_array_options(dg.el_channels, ["Red", "Green", "Blue"]);
yy += ui_get_radio_array_height(dg.el_channels) + spacing;
dg.el_all = create_checkbox(320, yy, "All colors?", ew / 2, eh, uivc_color_picker_all_colors, true, dg);

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Good", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    dg.el_picker, dg.el_channels, dg.el_all,
    el_confirm
);

return dg;