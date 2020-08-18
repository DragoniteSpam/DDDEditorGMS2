/// @param UIList
function uivc_scribble_color_select(argument0) {

	var list = argument0;
	var mode = Stuff.scribble;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    list.root.el_add.interactive = ds_list_size(list.entries) < 0xff;
	    list.root.el_remove.interactive = true;
	    list.root.el_name.interactive = true;
	    list.root.el_value.interactive = true;
    
	    ui_input_set_value(list.root.el_name, list.entries[| selection]);
	    list.root.el_value.value = global.__scribble_colours[? list.entries[| selection]];
	} else {
	    list.root.el_add.interactive = false;
	    list.root.el_remove.interactive = false;
	    list.root.el_name.interactive = false;
	    list.root.el_value.interactive = false;
	}


}
