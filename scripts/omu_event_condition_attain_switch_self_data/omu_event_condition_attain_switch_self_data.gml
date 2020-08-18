/// @param UIThing
function omu_event_condition_attain_switch_self_data(argument0) {

	var thing = argument0;
	var base_dialog = thing.root;
	var page = base_dialog.page;

	var index = page.condition_switch_self;

	var dw = 320;
	var dh = 320;

	var dg = dialog_create(dw, dh, "Global Switch", dialog_default, dc_close_no_questions_asked, thing);

	var columns = 1;
	var spacing = 16;
	var ew = dw / columns - spacing * 2;
	var eh = 24;

	var yy = 64;

	var el_list = create_radio_array(16, yy, "Switches", ew, eh, uivc_event_condition_attain_switch_self_index, index, dg);
	create_radio_array_options(el_list, ["A", "B", "C", "D"]);
	dg.el_list = el_list;

	var b_width = 128;
	var b_height = 32;
	var el_close = create_button(dw / 2 - b_width / 2, dh - 32 - b_height / 2, "Done", b_width, b_height, fa_center, dmu_dialog_commit, dg);

	ds_list_add(dg.contents, el_list, el_close);

	return dg;


}
