/// @param Dialog

var dw = 960;
var dh = 640;

var dg = dialog_create(dw, dh, "Data Settings: Game Constants", dialog_default, dc_close_no_questions_asked, argument0);

var columns = 3;
var ew = dw / columns - 64;
var eh = 24;

var c2 = dw / columns;
var c3 = dw * 2 / columns;

var vx1 = ew / 3;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var spacing = 16;

var yy = 64;
var yy_base = 64;

var el_list = create_list(32, yy, "Constants", "<no constants>", ew, eh, 16, uivc_list_selection_constant, false, dg, Stuff.all_game_constants);
el_list.numbered = true;
el_list.entries_are = ListEntries.INSTANCES;
dg.el_list = el_list;

yy = yy + ui_get_list_height(el_list) + spacing;

var el_add = create_button(32, yy, "Add Constant", ew, eh, fa_center, omu_global_constant_add, dg);
dg.el_add = el_add;

yy = yy + el_add.height + spacing;

var el_remove = create_button(32, yy, "Remove Constant", ew, eh, fa_center, omu_global_constant_remove, dg);
dg.el_remove = el_remove;

yy = yy + el_remove.height + spacing;

yy = yy_base;

var el_name = create_input(c2 + 32, yy, "Name:", ew, eh, uivc_global_constant_name, 0, "", "16 characters", validate_string, ui_value_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name = el_name;

yy = yy + el_name.height + spacing;

var el_type = create_radio_array(c2 + 32, yy, "Type:", ew, eh, uivc_input_constant_type, 0, dg);
create_radio_array_options(el_type, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code", "Color", "Mesh", "Tileset", "Tile", "Autotile",
    "Audio (BGM)", "Audio (SE)", "Animation"]);
el_type.interactive = false;
dg.el_type = el_type;

yy = yy + ui_get_radio_array_height(el_type) + spacing;

var el_type_ext = create_button(c2 + 32, yy, "Other Data Types", ew, eh, fa_middle, dialog_create_constant_types_ext, dg);
el_type_ext.interactive = false;
dg.el_type_ext = el_type_ext;

yy = yy_base;

var el_value_code = create_input_code(c3 + 32, yy, "Value:", ew, eh, vx1, vy1, vx2, vy2, "", uivc_input_constant_value, dg);
el_value_code.enabled = false;
dg.el_value_code = el_value_code;
var el_value_string = create_input(c3 + 32, yy, "Value:", ew, eh, uivc_input_constant_value, "", "", "text", validate_string, ui_value_string, 0, 1, 160, vx1, vy1, vx2, vy2, dg);
el_value_string.enabled = false;
dg.el_value_string = el_value_string;
var el_value_real = create_input(c3 + 32, yy, "Value:", ew, eh, uivc_input_constant_value, "", "0", "number", validate_double, ui_value_real, -1 << 31, 1 << 31 - 1, 10, vx1, vy1, vx2, vy2, dg);
el_value_real.enabled = false;
dg.el_value_real = el_value_real;
var el_value_int = create_input(c3 + 32, yy, "Value:", ew, eh, uivc_input_constant_value, "", "0", "int", validate_int, ui_value_real, -1 << 31, 1 << 31 - 1, 11, vx1, vy1, vx2, vy2, dg);
el_value_int.enabled = false;
dg.el_value_int = el_value_int;
var el_value_bool = create_checkbox(c3 + 32, yy, "Value", ew, eh, uivc_input_constant_value, "", false, dg);
el_value_bool.enabled = false;
dg.el_value_bool = el_value_bool;
var el_value_color = create_color_picker(c3 + 32, yy, "Color", ew, eh, uivc_input_constant_value, "", c_black, vx1, vy1, vx2, vy2, dg);
el_value_color.enabled = false;
dg.el_value_color = el_value_color;
var el_type_guid = create_list(c3 + 32, yy, "Select a Type", "<no types>", ew, eh, 8, uivc_input_constant_type_guid, false, dg);
el_type_guid.enabled = false;
el_type_guid.entries_are = ListEntries.INSTANCES;
dg.el_type_guid = el_type_guid;
var el_value_other = create_list(c3 + 32, yy, "Data:", "<no data>", ew, eh, 20, null, false, dg);
el_value_other.enabled = false;
el_value_other.entries_are = ListEntries.INSTANCES;
dg.el_value_other = el_value_other;

var el_value_data = create_list(c3 + 32, yy + ui_get_list_height(el_type_guid) + spacing, "Instance:", "<no data>", ew, eh, 8, null, false, dg);
el_value_data.enabled = false;
el_value_data.entries_are = ListEntries.INSTANCES;
dg.el_value_data = el_value_data;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list, el_name, el_add, el_remove, el_type, el_type_ext, el_type_guid,
    el_value_code, el_value_string, el_value_real, el_value_int, el_value_bool, el_value_color, el_value_other, el_value_data,
    el_confirm
);

return dg;