/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);

list.root.el_outbound_name.value = list.root.event.outbound[| selection];