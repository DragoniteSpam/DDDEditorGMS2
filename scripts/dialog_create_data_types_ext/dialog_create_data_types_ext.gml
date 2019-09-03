/// @param Dialog

var dw = 320;
var dh = 560;

var dg = dialog_create(dw, dh, "Other Data Types", dialog_default, dc_close_no_questions_asked, argument0);

var columns = 1;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var b_width = 128;
var b_height = 32;

var spacing = 16;
var n_slots = 14;

var yy = 64;

var el_list = create_radio_array(16, yy, "All Data Types: ", ew, eh, uivc_input_data_property_type_ext, argument0.root.selected_property.type, dg);
create_radio_array_options(el_list, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code", "Color", "Mesh", "Tileset", "Tile", "Autotile", "Audio (BGM)", "Audio (SE)", "Animation", "Entity"]);
// individual entities are disallowed by data types but they still need to be an entry here
// so that any types that get added in the future aren't off-by-one in this menu
el_list.contents[| DataTypes.ENTITY].interactive = false;

dg.el_list = el_list;

yy = yy + ui_get_radio_array_height(el_list) + spacing;

var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_close_no_questions_asked, dg, HelpPages.AUTOTILES, fa_center);

ds_list_add(dg.contents, el_list,
    el_confirm);

keyboard_string = "";

return dg;