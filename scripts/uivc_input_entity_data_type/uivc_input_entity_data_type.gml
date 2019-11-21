/// @param UIRadio

var radio = argument0;
var entity = radio.root.root.entity;
var selection = ui_list_selection(radio.root.root.el_list);

entity.generic_data[| selection].type = radio.value;

/*dialog_data_type_disable(radio.root.root);
dialog_data_type_enable_by_type(radio.root.root);*/