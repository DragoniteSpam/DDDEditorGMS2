/// @param UIButton

var button = argument0;
var list = button.root.el_map_list;
var index = ui_list_selection(list);
var map = Stuff.all_maps[| index];

load_a_map(map, map.version);