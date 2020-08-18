/// @param UIList
/// @param index
function ui_list_colors_asset_files(argument0, argument1) {

	var list = argument0;
	var index = argument1;
	var file_data = list.entries[| index];

	return file_data.compressed ? c_blue : c_black;


}
