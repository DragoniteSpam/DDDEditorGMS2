/// @param UIList
/// @param index
function ui_list_colors(argument0, argument1) {

	var list = argument0;
	var index = argument1;

	return (ds_list_size(list.entry_colors) > index) ? list.entry_colors[| index] : c_black;


}
