/// @param Dialog

var dw = 640;
var dh = 640;

var dg = dialog_create(dw, dh, "Data Settings: Global Switches", dialog_default, dc_close_no_questions_asked, argument0);

var ew = dw / 2 - 64;
var eh = 24;

var vx1 = ew / 2 + 16;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var c2 = dw / 2;
var spacing = 16;

var yy = 64;
var yy_start = 64;

var n_switches = ds_list_size(Stuff.switches);
var el_list = create_list(32, yy, "Global Switches (" + string(n_switches) + ")", "<no swiches>", ew, eh, 20, uivc_list_selection_global_switches, false, dg);
for (var i = 0; i < n_switches; i++) {
    var sw_data = Stuff.switches[| i];
    create_list_entries(el_list, sw_data[0] + ": " + Stuff.tf[sw_data[1]]);
}
el_list.numbered = true;
dg.el_list = el_list;
yy = yy + ui_get_list_height(el_list) + spacing;

yy = yy_start;
var el_max = create_input(c2 + 32, yy, "Maximum", ew, eh, dialog_create_commit_switches_resize, 0, string(n_switches), "0...65535", validate_int, ui_value_real, 0, 65535, 5, vx1, vy1, vx2, vy2, dg);
el_max.require_enter = true;
yy = yy + el_max.height + spacing;

yy = yy + eh + spacing;

var el_name = create_input(c2 + 32, yy, "Switch name:", ew, eh, uivc_global_switch_name, 0, "", "16 characters", validate_string, ui_value_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
yy = yy + el_name.height + spacing;
dg.el_name = el_name;
var el_default = create_checkbox(c2 + 32, yy, "Default value", ew, eh, uivc_global_switch_default, 0, false, dg);
yy = yy + el_default.height + spacing;
dg.el_default = el_default;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list, el_name, el_default, el_max,
    el_confirm);

return dg;