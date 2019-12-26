/// @param UIRadio

var radio = argument0;
var base_dialog = radio.root.root;
var map = Stuff.map.active_map;
var selection = ui_list_selection(base_dialog.el_list);

map.generic_data[| selection].type = radio.value;

dialog_map_data_type_disable(base_dialog);
dialog_map_data_enable_by_type(base_dialog);