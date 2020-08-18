/// @param UIInput
function uivc_input_graphic_set_frames_v(argument0) {

	var input = argument0;
	var list = input.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    list.entries[| selection].vframes = real(input.value);
	}


}
