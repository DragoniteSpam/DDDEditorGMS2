/// @param Dialog

var dw = 960;
var dh = 640;

var dg = dialog_create(dw, dh, "Data Settings: Game Constants", dialog_default, dc_close_no_questions_asked, argument0);

var columns = 3;
var ew = dw / columns - 64;
var eh = 24;

var col1_x = 32;
var col2_x = dw / columns + 32;
var col3_x = dw * 2 / columns + 32;

var vx1 = ew / 3;
var vy1 = 0;
var vx2 = ew;
var vy2 = eh;

var spacing = 16;

var yy = 64;
var yy_base = 64;

var el_list = create_list(col1_x, yy, "Constants", "<no constants>", ew, eh, 16, uivc_list_selection_constant, false, dg, Stuff.all_game_constants);
el_list.numbered = true;
el_list.entries_are = ListEntries.INSTANCES;
el_list.onmiddleclick = omu_global_constant_alphabetize;
dg.el_list = el_list;

yy += ui_get_list_height(el_list) + spacing;

var el_add = create_button(col1_x, yy, "Add Constant", ew, eh, fa_center, omu_global_constant_add, dg);
dg.el_add = el_add;

yy += el_add.height + spacing;

var el_remove = create_button(col1_x, yy, "Remove Constant", ew, eh, fa_center, omu_global_constant_remove, dg);
dg.el_remove = el_remove;

yy += el_remove.height + spacing;

var el_alphabetize = create_button(col1_x, yy, "Alphabetize", ew, eh, fa_center, omu_global_constant_alphabetize, dg);
dg.el_remove = el_alphabetize;

yy += el_alphabetize.height + spacing;

yy = yy_base;

var el_name = create_input(col2_x, yy, "Name:", ew, eh, uivc_global_constant_name, "", "16 characters", validate_string, 0, 1, VISIBLE_NAME_LENGTH, vx1, vy1, vx2, vy2, dg);
dg.el_name = el_name;

yy += el_name.height + spacing;

var el_type = create_radio_array(col2_x, yy, "Type:", ew, eh, uivc_input_constant_type, 0, dg);
create_radio_array_options(el_type, [
    "Int", "Enum", "Float", "String", "Boolean", "Data", "Code", "Color", "Mesh", "Tileset", "Tile", "Autotile",
    "Audio (BGM)", "Audio (SE)", "Animation"
]);
el_type.contents[| DataTypes.TILE].interactive = false;
el_type.interactive = false;
dg.el_type = el_type;

yy += ui_get_radio_array_height(el_type) + spacing;

var el_type_ext = create_button(col2_x, yy, "Other Data Types", ew, eh, fa_middle, omu_global_data_select_type, dg);
el_type_ext.interactive = false;
dg.el_type_ext = el_type_ext;

yy = yy_base;

var el_value_code = create_input_code(col3_x, yy, "Value:", ew, eh, vx1, vy1, vx2, vy2, "", uivc_input_constant_value_string, dg);
el_value_code.enabled = false;
dg.el_value_code = el_value_code;
var el_value_string = create_input(col3_x, yy, "Value:", ew, eh, uivc_input_constant_value_string, "", "text", validate_string, 0, 1, 160, vx1, vy1, vx2, vy2, dg);
el_value_string.enabled = false;
dg.el_value_string = el_value_string;
var el_value_real = create_input(col3_x, yy, "Value:", ew, eh, uivc_input_constant_value_real, "0", "number", validate_double, -0x80000000, 0x7fffffff, 10, vx1, vy1, vx2, vy2, dg);
el_value_real.enabled = false;
dg.el_value_real = el_value_real;
var el_value_int = create_input(col3_x, yy, "Value:", ew, eh, uivc_input_constant_value_real, "0", "int", validate_int, -0x80000000, 0x7fffffff, 11, vx1, vy1, vx2, vy2, dg);
el_value_int.enabled = false;
dg.el_value_int = el_value_int;
var el_value_bool = create_checkbox(col3_x, yy, "Value", ew, eh, uivc_input_constant_value_real, false, dg);
el_value_bool.enabled = false;
dg.el_value_bool = el_value_bool;
var el_value_color = create_color_picker(col3_x, yy, "Color", ew, eh, uivc_input_constant_value_real, c_black, vx1, vy1, vx2, vy2, dg);
el_value_color.enabled = false;
dg.el_value_color = el_value_color;
// this is for selecting the datadata type
var el_type_guid = create_list(col3_x, yy, "Select a Type", "<no types>", ew, eh, 8, uivc_input_constant_type_guid, false, dg, /* no external entry list */);
el_type_guid.enabled = false;
el_type_guid.entries_are = ListEntries.INSTANCES;
dg.el_type_guid = el_type_guid;
// this is for non-datadata data - meshes, battlers, audio, etc
var el_value_other = create_list(col3_x, yy, "Data:", "<no data>", ew, eh, 20, uivc_input_constant_value_guid, false, dg, noone);
el_value_other.enabled = false;
el_value_other.entries_are = ListEntries.INSTANCES;
dg.el_value_other = el_value_other;
// this is for datadata data - it's positioned in a different place
var el_value_data = create_list(col3_x, yy + ui_get_list_height(el_type_guid) + spacing, "Instance:", "<no data>", ew, eh, 8, uivc_input_constant_value_guid, false, dg, noone);
el_value_data.enabled = false;
el_value_data.entries_are = ListEntries.INSTANCES;
dg.el_value_data = el_value_data;
// for events
var el_event = create_button(col3_x, yy, "Event: ", ew, eh, fa_left, uivc_button_constant_value_event_graph, dg, Stuff.all_events);
el_event.enabled = false;
dg.el_event = el_event;
var el_event_entrypoint = create_button(col3_x, yy + el_event.height + spacing, "Entrypoint: ", ew, eh, fa_left, omu_entity_get_event_entrypoint, dg);
el_event_entrypoint.enabled = false;
dg.el_event_entrypoint = el_event_entrypoint;

var b_width = 128;
var b_height = 32;
var el_confirm = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents,
    el_list,
    el_name,
    el_add,
    el_remove,
    el_alphabetize,
    // common
    el_type,
    el_type_ext,
    el_type_guid,
    // values
    el_value_code,
    el_value_string,
    el_value_real,
    el_value_int,
    el_value_bool,
    el_value_color,
    el_value_other,
    el_value_data,
    el_event,
    el_event_entrypoint,
    // done
    el_confirm
);

return dg;