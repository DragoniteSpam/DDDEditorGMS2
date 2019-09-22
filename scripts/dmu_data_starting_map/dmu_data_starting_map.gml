/// @param UIButton

var button = argument0;
var list = button.root.el_map_list;

var index = ui_list_selection(list);
Stuff.game_starting_map = list.entries[| index].GUID;