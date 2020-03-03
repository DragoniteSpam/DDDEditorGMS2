/// @param EventNode
/// @param index

var node = argument0;
var index = argument1;

var dw = 640;
var dh = 360;

var dg = dialog_create(dw, dh, "Condition: Self Variable", dialog_default, dc_close_no_questions_asked, node);
dg.node = node;
dg.index = index;

// data[| 0] is already known
var list_index = node.custom_data[| 1];
var list_comparison = node.custom_data[| 2];
var list_value = node.custom_data[| 3];
// data[| 4] not used

var columns = 2;
var ew = (dw - 64) / columns;
var eh = 24;

var c2 = dw / columns;

var vx1 = dw / 4;
var vy1 = 0;
var vx2 = vx1 + (ew - vx1);
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;

var el_list = create_radio_array(16, yy, "Self Variables:", ew, eh, uivc_list_event_condition_self_index, list_index[| index], dg);
create_radio_array_options(el_list, ["A", "B", "C", "D"]);
dg.el_list = el_list;

// reset yy, except there's no point, since it's already at the top

var el_comparison = create_radio_array(c2 + 16, yy, "Comparison", ew, eh, uivc_check_event_condition_comparison, list_comparison[| index], dg);
create_radio_array_options(el_comparison, ["Less (<)", "Less or Equal (<=)", "Equal (==)", "Greater or Equal (>=)", "Greater (>)", "Not Equal (!=)"]);

yy += ui_get_radio_array_height(el_comparison) + spacing;

var el_value = create_input(c2 + 16, yy, "Value:", ew, eh, uivc_check_event_condition_value, list_value[| index], "float", validate_double, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
dg.el_value = el_value;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list, el_comparison, el_value, el_close);

return dg;