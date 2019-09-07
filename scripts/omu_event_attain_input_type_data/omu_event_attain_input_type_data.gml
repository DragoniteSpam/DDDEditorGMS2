/// @param UIThing
/// @param EventNode
/// @param data-index

var thing = argument0;
var event_node = argument1;
var data_index = argument2;

// going to just put all of the available properties in here, i think, because that
// should make some things a bit easier

var dw = 320;
var dh = 560;

var dg = dialog_create(dw, dh, "Input Type", dialog_default, dc_close_no_questions_asked, thing);
dg.node = event_node;
dg.index = data_index;

var custom_data_text = event_node.custom_data[| 0];
var custom_data_index = event_node.custom_data[| 2];
var custom_data_type = event_node.custom_data[| 2];

var ew = dw - 64;
var eh = 24;

var yy = 64;
var spacing = 16;

var el_list = create_list(16, yy, "Destination Variable", "<no variables>", ew, eh, 10, uivc_list_event_attain_input_variable_index, false, dg);
for (var i = 0; i < ds_list_size(Stuff.variables); i++) {
    // @todo gml update
    var data = Stuff.variables[| i];
    create_list_entries(el_list, data[0]);
}
if (custom_data_index[| 0] > -1) {
    ds_map_add(el_list.selected_entries, custom_data_index[| 0], true);
}
dg.el_list = el_list;

yy = yy + ui_get_list_height(el_list) + spacing;

var el_type = create_radio_array(16, yy, "Input Types", ew, eh, uivc_list_event_attain_input_type_index, custom_data_type[| 0], dg);
create_radio_array_options(el_type, ["Text", "Text (Scribble safe)", "Integer", "Unsigned Integer", "Floating Point"]);
dg.el_type = el_type;

yy = yy + ui_get_radio_array_height(el_type) + spacing;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list, el_type, el_close);

return dg;