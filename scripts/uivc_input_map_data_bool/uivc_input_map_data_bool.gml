/// @param UICheckbox

var checkbox = argument0;
var map = Stuff.map.active_map;
var selection = ui_list_selection(checkbox.root.el_list);
var data = map.generic_data[| selection];

data.value_bool = checkbox.value;