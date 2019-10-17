/// @param Dialog
// wanted to make this an alias for dialog_create_data_types_ext. that didn't work.
// now it's just a copy / paste.

var dialog = argument0;

var dw = 560;
var dh = 480;

var dg = dialog_create(dw, dh, "Other Data Types", dialog_default, dc_close_no_questions_asked, dialog);

var columns = 2;
var ew = (dw - columns * 32) / columns;
var eh = 24;

var c2 = dw / columns;

var b_width = 128;
var b_height = 32;

var spacing = 16;
var n_slots = 14;

var yy = 64;

// if you can click on the button to spawn this dialog, selection is guaranteed to have a value
var selection = ui_list_selection(dialog.root.el_list);
var property = dialog.root.event.types[| selection];
var offset = DataTypes.AUDIO_BGM;

var el_list_1 = create_radio_array(16, yy, "All Data Types: ", ew, eh, uivc_input_event_node_custom_data_ext, property[1], dg);
create_radio_array_options(el_list_1, ["Int", "Enum", "Float", "String", "Boolean", "Data", "Code", "Color", "Mesh", "Tileset", "Tile", "Autotile"]);
var el_list_2 = create_radio_array(c2 + 16, yy, "", ew, eh, uivc_input_event_node_custom_data_ext_2, -1, dg);
if (property[1] - offset >= 0) {
    el_list_2.value = property[1] - offset;
}
create_radio_array_options(el_list_2, ["Audio (BGM)", "Audio (SE)", "Animation", "Entity", "Map", "Battler sprite", "Overworld sprite", "Particle", "UI image", "Misc. image"]);

dg.el_list_1 = el_list_1;
dg.el_list_2 = el_list_2;

var el_confirm = create_button(dw / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dc_close_no_questions_asked, dg, fa_center);

ds_list_add(dg.contents, el_list_1, el_list_2,
    el_confirm);

return dg;