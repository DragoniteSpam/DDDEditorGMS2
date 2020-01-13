/// @param UIList

var list = argument0;
var selection = ui_list_selection(list);
var base_dialog = list.root;

ui_input_set_value(base_dialog.el_name, Stuff.all_asset_flags[| selection]);