/// @param Dialog
// there's a fair amount of redundant code in here, and in the associated scripts.
// however, in this case, i've decided that a few lines of redundant code is better than
// the spaghetti that i had before.

var dialog = argument0;

var dw = 960;
var dh = 640;

var dg = dialog_create(dw, dh, "Data: Data", dialog_default, undefined, dialog);

dg.selected_data = noone;
dg.selected_property = noone;

var columns = 3;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var col1_x = dw * 0 / 3 + spacing;
var col2_x = dw * 1 / 3 + spacing;
var col3_x = dw * 2 / 3 + spacing;

var vx1 = dw / (columns * 2) - 16;
var vy1 = 0;
var vx2 = vx1 + dw / (columns * 2) - 16;
var vy2 = eh;

var b_width = 128;
var b_height = 32;

var n_slots = 14;

var yy = 64;
var yy_base = yy;

var el_list = create_list(16, yy, "Data Types: ", "<no data types>", ew, eh, n_slots, uivc_list_data_data, false, dg, Stuff.all_data);
el_list.render = ui_render_list_data_data;
el_list.render_colors = ui_list_color_data_type;
el_list.entries_are = ListEntries.INSTANCES;

dg.el_list_main = el_list;

yy += ui_get_list_height(el_list) + spacing;

var el_add = create_button(16, yy, "Add Data", ew, eh, fa_center, omu_data_add, dg);
yy += el_add.height + spacing;

var el_add_enum = create_button(16, yy, "Add Enum", ew, eh, fa_center, omu_data_enum_add, dg);
yy += el_add.height + spacing;

var el_remove = create_button(16, yy, "Remove", ew, eh, fa_center, omu_data_remove, dg);

// COLUMN 2
yy = yy_base;

var el_data_name = create_input(col2_x, yy, "Data Name:", ew, eh, uivc_input_data_name, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
el_data_name.interactive = false;
dg.el_data_name = el_data_name;

yy += el_data_name.height + spacing;

var el_list_p = create_list(col2_x, yy, "Properties: ", "<name is implicit>", ew, eh, n_slots, uivc_list_data_property, false, dg, noone);
el_list_p.render = ui_render_list_data_properties;
el_list_p.entries_are = ListEntries.INSTANCES;
dg.el_list_p = el_list_p;

yy += ui_get_list_height(el_list_p) + spacing;

var el_add_p = create_button(col2_x, yy, "Add Property", ew, eh, fa_center, omu_data_property_add, dg);
el_add_p.interactive = false;
dg.el_add_p = el_add_p;

yy += el_add_p.height + spacing;

var el_remove_p = create_button(col2_x, yy, "Remove Property", ew, eh, fa_center, omu_data_property_remove, dg);
el_remove_p.interactive = false;
dg.el_remove_p = el_remove_p;

// COLUMN 3
yy = yy_base;

var el_property_name = create_input(col3_x, yy, "Name:", ew, eh, uivc_input_data_property_name, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
el_property_name.interactive = false;
dg.el_property_name = el_property_name;

yy += el_property_name.height + spacing;

var el_property_type = create_radio_array(col3_x, yy, "Type:", ew, eh, uivc_input_data_property_type, 0, dg);
el_property_type.interactive = false;
create_radio_array_options(el_property_type, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code"]);
dg.el_property_type = el_property_type;

yy += ui_get_radio_array_height(el_property_type) + spacing;

var el_property_ext_type = create_button(col3_x, yy, "Other Data Types", ew, eh, fa_middle, omu_datadata_select_type, dg);
el_property_ext_type.interactive = false;

yy += el_property_ext_type.height + spacing;
dg.el_property_ext_type = el_property_ext_type;

var yy_top = yy;

// anything common to all data types
var el_property_size = create_input(col3_x, yy, "Capacity:", ew, eh, uivc_input_data_max_size, "1", "1...255", validate_int, 1, 255, 3, vx1, vy1, vx2, vy2, dg);
el_property_size.interactive = false;
dg.el_property_size = el_property_size;

yy += eh + spacing;

var el_property_default_code = create_input_code(col3_x, yy, "Default:", ew, eh, vx1, vy1, vx2, vy2, "", uivc_input_data_default_code, dg);
el_property_default_code.enabled = false;
dg.el_property_default_code = el_property_default_code;
var el_property_default_string = create_input(col3_x, yy, "Default:", ew, eh, uivc_input_data_default_string, "", "text", validate_string, 0, 1, 160, vx1, vy1, vx2, vy2, dg);
el_property_default_string.enabled = false;
dg.el_property_default_string = el_property_default_string;
var el_property_default_real = create_input(col3_x, yy, "Default:", ew, eh, uivc_input_data_default_real, "0", "number", validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
el_property_default_real.enabled = false;
dg.el_property_default_real = el_property_default_real;
var el_property_default_int = create_input(col3_x, yy, "Default:", ew, eh, uivc_input_data_default_int, "0", "int", validate_int, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
el_property_default_int.enabled = false;
dg.el_property_default_int = el_property_default_int;
var el_property_default_bool = create_checkbox(col3_x, yy, "Default", ew, eh, uivc_check_data_default_bool, false, dg);
el_property_default_bool.enabled = false;
dg.el_property_default_bool = el_property_default_bool;
var el_property_default_na = create_text(col3_x, yy, "Default Not Available", ew, eh, fa_left, ew, dg);
el_property_default_na.enabled = false;
dg.el_property_default_na = el_property_default_na;

yy += eh + spacing;

var yy_base_special = yy;

// data and enum - onmouseup is assigned when the radio button is clicked
var el_property_type_guid = create_button(col3_x, yy, "Select", ew, eh, fa_center, null, dg);
el_property_type_guid.enabled = false;
dg.el_property_type_guid = el_property_type_guid;

// int only
var el_property_min = create_input(col3_x, yy, "Min. Value:", ew, eh, uivc_input_data_value_min, "0", "+" + string(0x80000000), validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
el_property_min.enabled = false;
dg.el_property_min = el_property_min;

// string only
var el_property_char_limit = create_input(col3_x, yy, "Char. Limit:", ew, eh, uivc_input_data_char_limit, "20", "1000", validate_int, 1, 1000, 4, vx1, vy1, vx2, vy2, dg);
el_property_char_limit.enabled = false;
dg.el_property_char_limit = el_property_char_limit;

yy += eh + spacing;

// int and float only
var el_property_max = create_input(col3_x, yy, "Max. Value:", ew, eh, uivc_input_data_value_max, "0", "+" + string(-0x7fffffff), validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
el_property_max.enabled = false;
dg.el_property_max = el_property_max;

yy += eh + spacing;

var el_property_scale = create_radio_array(col3_x, yy, "Scale:", ew, eh, uivc_input_data_number_scale, 0, dg);
create_radio_array_options(el_property_scale, ["Linear", "Quadratic", "Exponential"]);
el_property_scale.enabled = false;
dg.el_property_scale = el_property_scale;

yy = yy_base_special;

yy += eh + spacing;

var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_default, dg, fa_center);

ds_list_add(dg.contents,
    el_list, el_add, el_add_enum, el_remove,
    el_data_name, el_list_p, el_add_p, el_remove_p,
    el_property_name, el_property_type, el_property_ext_type,
    el_property_size, el_property_type_guid, el_property_min, el_property_char_limit,
    el_property_max, el_property_scale,
    el_property_default_code, el_property_default_string, el_property_default_real,
    el_property_default_bool, el_property_default_int, el_property_default_na,
    el_confirm
);

return dg;