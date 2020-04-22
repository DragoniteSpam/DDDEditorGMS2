/// @param node
/// @param index
/// @param message
/// @param value

var node = argument0;
var index = argument1;
var message = argument2;
var value = argument3;

var dw = 560;
var dh = 320;

var dg = dialog_create(dw, dh, message, dialog_default, undefined, node);
dg.node = node;
dg.index = index;

var columns = 1;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var col1_x = dw * 0 / 3 + spacing;

var vx1 = 0;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var yy = 64;
var yy_base = yy;

var el_text = create_text(col1_x, yy, message, ew, eh, fa_left, ew, dg);
yy += el_text.height + spacing;

var el_input = create_input(col1_x, yy, "", ew, eh, uivc_list_event_attain_string, value, "", validate_string, 0, 1, 250, vx1, vy1, vx2, vy2, dg);
yy += el_input.height;

var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_default, dg, fa_center);

ds_list_add(dg.contents,
    el_text,
    el_input,
    el_confirm,
);

return dg;