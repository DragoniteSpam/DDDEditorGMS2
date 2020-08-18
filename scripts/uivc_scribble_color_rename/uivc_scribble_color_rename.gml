/// @param UIInput
function uivc_scribble_color_rename(argument0) {

	var input = argument0;
	var list = input.root.el_list;
	var mode = Stuff.scribble;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    if (!ds_map_exists(global.__scribble_colours, input.value)) {
	        var value = global.__scribble_colours[? list.entries[| selection]];
	        ds_map_delete(global.__scribble_colours, list.entries[| selection]);
	        global.__scribble_colours[? input.value] = value;
	        list.entries[| selection] = input.value;
	        mode.scribble = noone;
	        scribble_flush();
	    }
	}


}
