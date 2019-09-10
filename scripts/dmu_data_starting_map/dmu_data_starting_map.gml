/// @param UIThing

var thing = argument0;
var list = thing.root.el_map_list;

var index = ui_list_selection(list);
Stuff.game_map_starting = list.entries[| index].GUID;