/// @param UIThing
/// @param EventNode
/// @param data-index

var thing = argument0;
var event_node = argument1;
var data_index = argument2;

// going to just put all of the available properties in here, i think, because that
// should make some things a bit easier

var dw = 320;
var dh = 560;

var dg = dialog_create(dw, dh, "Modify Global Variable", dialog_default, dc_close_no_questions_asked, thing);
dg.node = event_node;
dg.index = data_index;

var custom_data_variable = event_node.custom_data[| 0];
var custom_data_value = event_node.custom_data[| 1];
var custom_data_relative = event_node.custom_data[| 2];

var ew = dw - 64;
var eh = 24;

var vx1 = dw / 4 + 16;
var vy1 = 0;
var vx2 = vx1 + (ew - vx1);
var vy2 = eh;

var yy = 64;
var spacing = 16;

var el_list = create_list(16, yy, "Variables", "<no variables>", ew, eh, 14, uivc_list_event_attain_variable_index, false, dg);
for (var i = 0; i < ds_list_size(Stuff.variables); i++) {
    // @gml update
    var data = Stuff.variables[| i];
    create_list_entries(el_list, data[0]);
}
if (custom_data_variable[| 0] > -1) {
    ui_list_select(el_list, custom_data_variable[| 0]);
}
dg.el_list = el_list;

yy += ui_get_list_height(el_list) + spacing;

var el_value = create_input(16, yy, "Value", ew, eh, uivc_check_event_attain_variable_value, custom_data_value[| 0], "float", validate_double, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
dg.el_value = el_value;

yy += el_value.height + spacing;

var el_relative = create_checkbox(16, yy, "Relative?", ew, eh, uivc_check_event_attain_variable_relative, custom_data_relative[| 0], dg);
dg.el_relative = el_relative;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list, el_value, el_relative, el_close);

return dg;