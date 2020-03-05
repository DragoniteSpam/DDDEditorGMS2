/// @param Dialog

var dw = 640;
var dh = 640;

var dg = dialog_create(dw, dh, "Data Settings: Global Variables", dialog_default, dc_close_no_questions_asked, argument0);

var ew = dw / 2 - 64;
var eh = 24;

var vx1 = ew / 2 + 16;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var c2 = dw / 2;
var spacing = 16;

var yy = 64;
var yy_start = 64;

var n_variables= ds_list_size(Stuff.variables);
var el_list = create_list(32, yy, "Global Variables (" + string(n_variables) + ")", "<no variables>", ew, eh, 18, uivc_list_selection_global_variables, false, dg);
for (var i = 0; i < n_variables; i++) {
    var var_data = Stuff.variables[| i];
    create_list_entries(el_list, var_data[0] + ": " + string(var_data[1]));
}
el_list.numbered = true;
dg.el_list = el_list;
yy += ui_get_list_height(el_list) + spacing;

yy = yy_start;
var el_max = create_input(c2 + 32, yy, "Maximum", ew, eh, dialog_create_commit_variable_resize, string(n_variables), "0...65535", validate_int, 0, 65535, 5, vx1, vy1, vx2, vy2, dg);
el_max.require_enter = true;
yy += el_max.height + spacing;

yy += eh + spacing;

var el_name = create_input(c2 + 32, yy, "Variable name:", ew, eh, uivc_global_variable_name, "", "", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
yy += el_name.height + spacing;
dg.el_name = el_name;
var el_default = create_input(c2 + 32, yy, "Default value", ew, eh, uivc_global_variable_default, 0, "number", validate_double, -BILLION, BILLION, 12, vx1, vy1, vx2, vy2, dg);
yy += el_default.height + spacing;
dg.el_default = el_default;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list, el_name, el_default, el_max,
    el_confirm);

return dg;