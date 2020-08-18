/// @param Dialog
function dc_settings_switch_resize(argument0) {

	var value = real(argument0.root.root.value);
	var times = ds_list_size(Stuff.switches) - value;

	repeat (times) {
	    ds_list_pop(Stuff.switches);
	}

	var base_dialog = argument0.root.root.root;
	if (value <= ui_list_selection(base_dialog.el_list)) {
	    ui_list_deselect(base_dialog.el_list);
	}

	while (ds_list_size(base_dialog.el_list.entries) > value) {
	    ds_list_pop(base_dialog.el_list.entries);
	}

	ui_list_reset_view(base_dialog.el_list);

	dialog_destroy();


}
