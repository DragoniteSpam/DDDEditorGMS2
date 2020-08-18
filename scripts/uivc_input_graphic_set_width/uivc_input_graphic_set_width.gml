/// @param UIInput
function uivc_input_graphic_set_width(argument0) {

	var input = argument0;
	var list = input.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var data = list.entries[| selection];
	    data.width = real(input.value);
    
	    data_image_force_power_two(data);
	    data_image_npc_frames(data);
	}


}
