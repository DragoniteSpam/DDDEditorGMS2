/// @param UIList

var selection = ui_list_selection(argument0);
var base_dialog = argument0.root;

ui_input_set_value(base_dialog.el_name, Stuff.all_event_triggers[| selection]);