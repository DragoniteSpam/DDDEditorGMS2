/// @param UIThing
/// @param EventNode
/// @param data-index

var thing = argument0;
var event_node = argument1;
var data_index = argument2;

// going to just put all of the available properties in here, i think, because that
// should make some things a bit easier

var dw = 320;
var dh = 320;

var dg = dialog_create(dw, dh, "Modify Self Switch", dialog_default, dc_close_no_questions_asked, thing);
dg.node = event_node;
dg.index = data_index;

var custom_data_entity = event_node.custom_data[| 0];
var custom_data_switch = event_node.custom_data[| 1];
var custom_data_state = event_node.custom_data[| 2];

var ew = dw - 64;
var eh = 24;

var yy = 64;
var spacing = 16;

var el_choices = create_radio_array(16, yy, "Switches", ew, eh, uivc_list_event_attain_self_switch_index, custom_data_switch[| 0], dg);
create_radio_array_options(el_choices, ["A", "B", "C", "D"]);
dg.el_choices = el_choices;

yy = yy + ui_get_radio_array_height(el_choices) + spacing;

var el_state = create_checkbox(16, yy, "Enabled?", ew, eh, uivc_check_event_attain_switch_state, 0, custom_data_state[|0], dg);
dg.el_state = el_state;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_choices, el_state, el_close);

return dg;