/// @param UIInput

var input = argument0;
var map = Stuff.map.active_map;
var selection = ui_list_selection(input.root.el_list);

map.generic_data[| selection].name = input.value;