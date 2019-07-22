/// @param UIList

var selection = ui_list_selection(argument0);
var sw_data = Stuff.switches[| selection];
var base_dialog = argument0.root;

base_dialog.el_name.value = sw_data[0];
base_dialog.el_default.value = sw_data[1];