/// @param UICheckbox
function uivc_input_graphic_texture_exclude(argument0) {

	var checkbox = argument0;
	var list = checkbox.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    list.entries[| selection].texture_exclude = checkbox.value;
	}


}
