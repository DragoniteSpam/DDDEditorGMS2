/// @param EventNode
/// @param index

var node = argument0;
var index = argument1;

var dw = 320;
var dh = 320;

var dg = dialog_create(dw, dh, "Condition: Self Switch", dialog_default, dc_close_no_questions_asked, node);
dg.node = node;
dg.index = index;

// data[| 0] is already known
var list_index = node.custom_data[| 1];
// data[| 2] not used
var list_value = node.custom_data[| 3];
// data[| 4] not used

var columns = 1;
var ew = (dw - 64) / columns;
var eh = 24;

var yy = 64;
var spacing = 16;

var el_list = create_radio_array(16, yy, "Self Switches:", ew, eh, uivc_list_event_condition_self_index, list_index[| index], dg);
create_radio_array_options(el_list, ["A", "B", "C", "D"]);
dg.el_list = el_list;

yy = yy + ui_get_radio_array_height(el_list) + spacing;

var el_state = create_checkbox(16, yy, "Is enabled?", ew, eh, uivc_check_event_condition_value, 0, list_value[| index], dg);
dg.el_state = el_state;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list, el_state, el_close);

return dg;