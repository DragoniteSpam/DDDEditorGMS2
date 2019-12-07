/// @param UIButton

var button = argument0;
var list = button.root.el_list;

var sorted = ds_list_sort_name_sucks(list.entries);
ds_list_destroy(list.entries);
list.entries = sorted;
Stuff.all_game_constants = sorted;
ui_list_deselect(list);