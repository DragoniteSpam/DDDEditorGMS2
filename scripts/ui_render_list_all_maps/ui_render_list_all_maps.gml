/// @param UIList
/// @param x
/// @param y
function ui_render_list_all_maps(argument0, argument1, argument2) {

	var list = argument0;
	var xx = argument1;
	var yy = argument2;

	var oldtext = list.text;
	list.text = list.text + string(ds_list_size(list.entries));

	ds_list_clear(list.entry_colors);
	for (var i = 0; i < ds_list_size(list.entries); i++) {
	    ds_list_add(list.entry_colors, (Stuff.game_starting_map == list.entries[| i].GUID) ? c_blue : c_black);
	}

	ui_render_list(list, xx, yy);

	list.text = oldtext;


}
