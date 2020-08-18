/// @param UIButton
function uivc_input_graphic_set_dim_crop(argument0) {

	var button = argument0;
	var list = button.root.el_list;
	var selection = ui_list_selection(list);

	if (selection + 1) {
	    var data = list.entries[| selection];
	    // @todo impelment a cutoff value
	    var dim = sprite_get_cropped_dimensions(data.picture, 0, 127);
	    // @todo implement a value to round to
	    var round_to = 16;
	    data.width = round_ext(dim[vec3.xx], round_to);
	    data.height = round_ext(dim[vec3.yy], round_to);
	    list.root.el_dim_x.value = string(data.width);
	    list.root.el_dim_y.value = string(data.height);
    
	    data_image_npc_frames(data);
	}


}
