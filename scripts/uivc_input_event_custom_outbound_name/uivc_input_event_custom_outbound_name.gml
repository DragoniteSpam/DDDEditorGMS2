/// @param UIInput

var input = argument0;

var selection = ui_list_selection(input.root.el_outbound);
input.root.event.outbound[| selection] = input.value;