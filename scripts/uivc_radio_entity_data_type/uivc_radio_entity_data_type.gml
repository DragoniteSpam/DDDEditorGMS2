/// @param UIRadio

var radio = argument0;
var base_dialog = radio.root.root;
var entity = base_dialog.entity;
var selection = ui_list_selection(base_dialog.el_list);

entity.generic_data[| selection].type = radio.value;

dialog_entity_data_type_disable(base_dialog);
dialog_entity_data_enable_by_type(base_dialog);