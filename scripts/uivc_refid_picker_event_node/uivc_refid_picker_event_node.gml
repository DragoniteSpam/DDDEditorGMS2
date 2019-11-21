/// @param UIList

var list = argument0;
var node = list.root.node;
var index = list.root.index;
var selection = ui_list_selection(list);

var data_list = node.custom_data[| index];
if (selection >= 0) {
    data_list[| 0] = list.entries[| selection].REFID;
} else {
    data_list[| 0] = 0;
}