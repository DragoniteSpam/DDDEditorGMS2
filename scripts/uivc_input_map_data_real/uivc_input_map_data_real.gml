/// @param UIInput
function uivc_input_map_data_real(argument0) {

	var input = argument0;
	var map = Stuff.map.active_map;
	var selection = ui_list_selection(input.root.el_list);
	var data = map.generic_data[| selection];

	data.value_real = real(input.value);


}
