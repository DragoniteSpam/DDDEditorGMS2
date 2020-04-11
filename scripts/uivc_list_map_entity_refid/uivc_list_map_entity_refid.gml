/// @param UIList

var list = argument0;
var map = Stuff.map.active_map;
var selection = ui_list_selection(list);
var generic_index = ui_list_selection(list.root.el_list);

if (selection + 1) {
    map.generic_data[| generic_index].value_data = list.entries[| selection].REFID;
}