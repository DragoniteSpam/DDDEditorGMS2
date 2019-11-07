/// @param EventNode
/// @param data-index

var node = argument0;
var index = argument1;

// going to just put all of the available properties in here, i think, because that
// should make some things a bit easier

var dw = 320;
var dh = 560;

var dg = dialog_create(dw, dh, "Condition: Global Switch", dialog_default, dc_close_no_questions_asked, node);
dg.node = node;
dg.index = index;

// data[| 0] is already known
var list_index = node.custom_data[| 1];
// data[| 2] not used
var list_value = node.custom_data[| 3];
// data[| 4] not used

var ew = dw - 64;
var eh = 24;

var yy = 64;
var spacing = 16;

var el_list = create_list(16, yy, "Switches", "<no switches>", ew, eh, 14, uivc_list_event_condition_index, false, dg);
for (var i = 0; i < ds_list_size(Stuff.switches); i++) {
    // @todo gml update
    var data = Stuff.switches[| i];
    create_list_entries(el_list, data[0]);
}

if (list_index[| index] > -1) {
    ui_list_select(el_list, list_index[| index]);
}
dg.el_list = el_list;

yy = yy + ui_get_list_height(el_list) + spacing;

var el_state = create_checkbox(16, yy, "Is enabled?", ew, eh, uivc_check_event_condition_value, list_value[| index], dg);
dg.el_state = el_state;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list, el_state, el_close);

return dg;