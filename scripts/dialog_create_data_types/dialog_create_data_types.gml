
/// @param Dialog
// there's a fair amount of redundant code in here, and in the associated scripts.
// however, in this case, i've decided that a few lines of redundant code is better than
// the spaghetti that i had before.

Stuff.original_data = data_clone();

var dw = 960;
var dh = 640;

var dg = dialog_create(dw, dh, "Data: Data", dialog_note_changes, dc_close_data_discard, argument0, dc_close_data_discard);
dg.x = dg.x - 32;

dg.selected_data = noone;
dg.selected_property = noone;
dg.changed = false;

var columns = 3;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var vx1 = dw / (columns * 2) - 16;
var vy1 = 0;
var vx2 = vx1 + dw / (columns * 2) - 16;
var vy2 = vy1 + eh;

var b_width = 128;
var b_height = 32;

var spacing = 16;
var n_slots = 14;

var yy = 64;

var el_list = create_list(16, yy, "Data Types: ", "<no data types>", ew, eh, n_slots, uivc_list_data_data, false, dg);
el_list.render = ui_render_list_data_data;
el_list.entries_are = ListEntries.INSTANCES;

dg.el_list_main = el_list;

yy = yy + ui_get_list_height(el_list) + spacing;

var el_add = create_button(16, yy, "Add Data", ew, eh, fa_center, omu_data_add, dg);
yy = yy + el_add.height + spacing;

var el_add_enum = create_button(16, yy, "Add Enum", ew, eh, fa_center, omu_data_enum_add, dg);
yy = yy + el_add.height + spacing;

el_remove=create_button(16, yy, "Remove", ew, eh, fa_center, omu_data_remove, dg);

// COLUMN 2
yy=64;
var col2_x=dw/3+16;

var el_data_name=create_input(col2_x, yy, "Data Name:", ew, eh, uivc_input_data_name, "", "", "[A-Za-z0-9_]+", validate_string_internal_name, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
el_data_name.interactive=false;
dg.el_data_name=el_data_name;

yy=yy+el_data_name.height+spacing;

var el_list_p=create_list(col2_x, yy, "Properties: ", "<name is implicit>", ew, eh, n_slots, uivc_list_data_property, false, dg);
el_list_p.render=ui_render_list_data_properties;
el_list_p.entries_are=ListEntries.INSTANCES;
dg.el_list_p=el_list_p;

yy=yy+ui_get_list_height(el_list_p)+spacing;

var el_add_p=create_button(col2_x, yy, "Add Property", ew, eh, fa_center, omu_data_property_add, dg);
el_add_p.interactive=false;
dg.el_add_p=el_add_p;

yy=yy+el_add_p.height+spacing;

var el_remove_p=create_button(col2_x, yy, "Remove Property", ew, eh, fa_center, omu_data_property_remove, dg);
el_remove_p.interactive=false;
dg.el_remove_p=el_remove_p;

// COLUMN 3
yy=64;
var col3_x=dw*2/3+16;

var el_property_name=create_input(col3_x, yy, "Name:", ew, eh, uivc_input_data_property_name, "", "", "[A-Za-z0-9_]+", validate_string_internal_name, ui_value_string, 0, 1, 16, vx1, vy1, vx2, vy2, dg);
el_property_name.interactive=false;
dg.el_property_name=el_property_name;

yy=yy+el_property_name.height+spacing;

var el_property_type=create_radio_array(col3_x, yy, "Type:", ew, eh, uivc_input_data_property_type, 0, dg);
el_property_type.interactive=false;
create_radio_array_options(el_property_type, "Int", "Enum", "Float", "String", "Boolean", "Data");
dg.el_property_type=el_property_type;

yy=yy+ui_get_radio_array_height(el_property_type)+spacing;

var yy_top=yy;

// data and enum - onmouseup is assigned when the radio button is clicked
var el_property_type_guid=create_button(col3_x, yy, "Select", ew, eh, fa_center, null, dg);
el_property_type_guid.enabled=false;
dg.el_property_type_guid=el_property_type_guid;

// number only
var el_property_min=create_input(col3_x, yy, "Min. Value:", ew, eh, uivc_input_data_value_min, "", "0", "+"+string(-1<<31), validate_double, ui_value_real, -1<<31, 1<<31-1, 10, vx1, vy1, vx2, vy2, dg);
el_property_min.enabled=true;
dg.el_property_min=el_property_min;

// string only
var el_property_char_limit=create_input(col3_x, yy, "Char. Limit:", ew, eh, uivc_input_data_char_limit, "", "20", "1000", validate_int, ui_value_real, 1, 1000, 4, vx1, vy1, vx2, vy2, dg);
el_property_char_limit.enabled=false;
dg.el_property_char_limit=el_property_char_limit;

// bool only
var el_property_bool_note=create_text(col3_x, yy, "(No extra data)", ew, eh, fa_left, ew, dg);
el_property_bool_note.enabled=false;
dg.el_property_bool_note=el_property_bool_note;

yy=yy+eh+spacing;

// number only
var el_property_max=create_input(col3_x, yy, "Max. Value:", ew, eh, uivc_input_data_value_max, "", "0", "+"+string(-1<<31-1), validate_double, ui_value_real, -1<<31, 1<<31-1, 10, vx1, vy1, vx2, vy2, dg);
el_property_max.enabled=true;
dg.el_property_max=el_property_max;

yy=yy+eh+spacing;

var el_property_scale=create_radio_array(col3_x, yy, "Scale:", ew, eh, uivc_input_data_number_scale, 0, dg);
create_radio_array_options(el_property_scale, "Linear", "Quadratic", "Exponential");
el_property_scale.enabled=true;
dg.el_property_scale=el_property_scale;

yy=yy_top;

el_confirm=create_button(dw/2, dh-32-b_height/2, "Done", b_width, b_height, fa_center, dc_data_commit, dg, HelpPages.AUTOTILES, fa_center);

ds_list_add(dg.contents, el_list, el_add, el_add_enum, el_remove,
    el_data_name, el_list_p, el_add_p, el_remove_p,
    el_property_name, el_property_type,
    el_property_type_guid, el_property_min, el_property_char_limit, el_property_bool_note,
    el_property_max, el_property_scale,
    el_confirm);

keyboard_string="";

return dg;
