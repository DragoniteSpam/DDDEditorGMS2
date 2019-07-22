/// @param UIThing

var thing = argument0;
var base_dialog = thing.root;
var page = base_dialog.page;

var index = page.condition_variable_global;
var value = page.condition_variable_global_value;
var comparison = page.condition_variable_global_comparison;

var dw = 640;
var dh = 560;

var dg = dialog_create(dw, dh, "Global Variable", dialog_default, dc_close_no_questions_asked, thing);

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

var el_list = create_list(16, yy, "Variables", "<no variables>", ew, eh, 16, uivc_event_condition_attain_variable_index, false, dg);
for (var i = 0; i < ds_list_size(Stuff.variables); i++) {
    // @todo gml update
    var data = Stuff.variables[| i];
    create_list_entries(el_list, data[0], c_black);
}
if (index > -1) {
    ds_map_add(el_list.selected_entries, index, true);
}
dg.el_list = el_list;

// reset yy, except there's no point, since it's already at the top

var el_comparison = create_radio_array(c2 + 16, yy, "Comparison", ew, eh, uivc_event_condition_attain_variable_comp, comparison, dg);
create_radio_array_options(el_comparison, "Less (<)", "Less or Equal (<=)", "Equal (==)", "Greater or Equal (>=)", "Greater (>)", "Not Equal (!=)");

yy = yy + ui_get_radio_array_height(el_comparison) + spacing;

var el_value = create_input(c2 + 16, yy, "Value:", ew, eh, uivc_event_condition_attain_variable_value, 0, value, "float", validate_double, ui_value_real, -(1 << 31), (1 << 31) - 1, 11, vx1, vy1, vx2, vy2, dg);
dg.el_value = el_value;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list, el_comparison, el_value, el_close);

return dg;