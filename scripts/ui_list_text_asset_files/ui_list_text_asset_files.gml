/// @param UIList
/// @param index
function ui_list_text_asset_files(argument0, argument1) {

	var list = argument0;
	var index = argument1;
	var file_data = list.entries[| index];

	return (index ? (file_data.internal_name + ".ddda") : "(master.dddd)") + (file_data.critical ? "" : "*");


}
