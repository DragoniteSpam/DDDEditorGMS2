/// @param root

var root = argument0;
var map = Stuff.map.active_map;

var dw = 640;
var dh = 640;

var dg = dialog_create(dw, dh, "Generic Data", dialog_default, dc_close_no_questions_asked, root);

var columns = 2;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var col1_x = 0 * dw / columns + 16;
var col2_x = 1 * dw / columns + 16;

var vx1 = ew / 2;
var vy1 = 0;
var vx2 = ew;
var vy2 = vy1 + eh;

var yy = 64;
var spacing = 16;
var slots = 16;

var el_list = create_list(col1_x, yy, "Generic Data: " + map.name, "<No data>", ew, eh, slots, uivc_list_map_data, false, dg, map.generic_data);
el_list.entries_are = ListEntries.INSTANCES;
dg.el_list = el_list;
yy += ui_get_list_height(el_list) + spacing;

var el_data_add = create_button(col1_x, yy, "Add Data", ew, eh, fa_center, omu_map_data_add, dg);
yy += el_data_add.height + spacing;

var el_data_remove = create_button(col1_x, yy, "Delete Data", ew, eh, fa_center, omu_map_data_remove, dg);
yy += el_data_remove.height + spacing;

yy = 64;

var el_name = create_input(col2_x, yy, "Name:", ew, eh, uivc_input_map_data_name, "", "[A-Za-z0-9_]+", validate_string_internal_name, 0, 1, INTERNAL_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
el_name.interactive = false;
dg.el_name = el_name;
yy += el_name.height + spacing;

var el_data_type = create_radio_array(col2_x, yy, "Type:", ew, eh, uivc_radio_map_data_type, 0, dg);
create_radio_array_options(el_data_type, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code" /* this is only the first couple of types, the rest are hidden behind a button */]);
el_data_type.interactive = false;
dg.el_data_type = el_data_type;
yy += ui_get_radio_array_height(el_data_type) + spacing;

var el_data_ext_type = create_button(col2_x, yy, "Other Data Types", ew, eh, fa_middle, omu_map_data_select_type, dg);
el_data_ext_type.interactive = false;
dg.el_data_ext_type = el_data_ext_type;
yy += el_data_ext_type.height + spacing;

var el_data_property_code = create_input_code(col2_x, yy, "Code:", ew, eh, vx1, vy1, vx2, vy2, "", uivc_input_map_data_code, dg);
el_data_property_code.interactive = false;
el_data_property_code.enabled = false;
dg.el_data_property_code = el_data_property_code;

var el_data_property_string = create_input(col2_x, yy, "Value:", ew, eh, uivc_input_map_data_string, "", "text", validate_string, 0, 1, 160, vx1, vy1, vx2, vy2, dg);
el_data_property_string.is_code = false;
el_data_property_string.interactive = false;
el_data_property_string.enabled = false;
dg.el_data_property_string = el_data_property_string;

var el_data_property_real = create_input(col2_x, yy, "Value:", ew, eh, uivc_input_map_data_real, "0", "number", validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
el_data_property_real.interactive = false;
el_data_property_real.enabled = false;
dg.el_data_property_real = el_data_property_real;

var el_data_property_int = create_input(col2_x, yy, "Value:", ew, eh, uivc_input_map_data_int, "0", "int", validate_int, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
el_data_property_int.interactive = false;
el_data_property_int.enabled = false;
dg.el_data_property_int = el_data_property_int;

var el_data_property_bool = create_checkbox(col2_x, yy, "Value", ew, eh, uivc_input_map_data_bool, false, dg);
el_data_property_bool.interactive = false;
el_data_property_bool.enabled = false;
dg.el_data_property_bool = el_data_property_bool;

var el_data_property_color = create_color_picker(col2_x, yy, "Color:", ew, eh, uivc_input_map_data_color, c_black, vx1, vy1, vx2, vy2, dg);
el_data_property_color.interactive = false;
el_data_property_color.enabled = false;
dg.el_data_property_color = el_data_property_color;

// for built-in data types the Select button won't appear, so the list can be slightly bigger
// and moved up on space; everything else is basically the same
var el_data_builtin_list = create_list(col2_x, yy, "Data", "<none>", ew, eh, 8, uivc_list_map_data_guid, false, dg, noone);
el_data_builtin_list.interactive = false;
el_data_builtin_list.enabled = false;
el_data_builtin_list.entries_are = ListEntries.INSTANCES;
dg.el_data_builtin_list = el_data_builtin_list;

//should probably take inspiration from dialog_create_data_types
var el_data_type_guid = create_button(col2_x, yy, "Select", ew, eh, fa_center, null, dg);
el_data_type_guid.interactive = false;
el_data_type_guid.enabled = false;
dg.el_data_type_guid = el_data_type_guid;
yy += el_data_type_guid.height + spacing;

var el_data_list = create_list(col2_x, yy, "Data", "<none>", ew, eh, 6, uivc_list_map_data_guid, false, dg, noone);
el_data_list.interactive = false;
el_data_list.enabled = false;
el_data_list.entries_are = ListEntries.INSTANCES;
dg.el_data_list = el_data_list;
yy += ui_get_list_height(el_data_list) + spacing;

var yy_base = yy;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list,
    el_data_add,
    el_data_remove,
    el_name,
    el_data_type,
    el_data_ext_type,
    el_data_type_guid,
    el_data_list,
    el_data_builtin_list,
    el_data_property_code,
    el_data_property_string,
    el_data_property_real,
    el_data_property_int,
    el_data_property_bool,
    el_data_property_color,
    el_confirm
);

return dg;