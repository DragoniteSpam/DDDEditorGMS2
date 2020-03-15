/// @param UIThing

var thing = argument0;
var base_dialog = thing.root;
var page = base_dialog.page;

var index = page.condition_switch_global;

var dw = 320;
var dh = 560;

var dg = dialog_create(dw, dh, "Global Switch", dialog_default, dc_close_no_questions_asked, thing);

var columns = 1;
var spacing = 16;
var ew = dw / columns - spacing * 2;
var eh = 24;

var yy = 64;

var el_list = create_list(16, yy, "Switches", "<no switches>", ew, eh, 16, uivc_event_condition_attain_switch_index, false, dg);
for (var i = 0; i < ds_list_size(Stuff.switches); i++) {
    // @gml update
    var data = Stuff.switches[| i];
    create_list_entries(el_list, data[0]);
}
if (index + 1) {
    ui_list_select(el_list, index);
}
dg.el_list = el_list;

var b_width = 128;
var b_height = 32;
var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

ds_list_add(dg.contents, el_list, el_close);

return dg;