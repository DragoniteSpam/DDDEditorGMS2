/// @param UIButton
function dmu_data_starting_map(argument0) {

	var button = argument0;
	var list = button.root.el_map_list;

	var index = ui_list_selection(list);
	Stuff.game_starting_map = list.entries[| index].GUID;


}
