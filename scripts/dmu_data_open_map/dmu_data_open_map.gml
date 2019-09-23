/// @param UIButton

var button = argument0;
var list = button.root.el_map_list;
var index = ui_list_selection(list);
var map = Stuff.all_maps[| index];

if (map != Stuff.active_map) {
	selection_clear();
	load_a_map(map);
}