/// @param UIRadio

var radio = argument0;

radio.root.root.selected_property.type = radio.value;

dialog_data_type_disable(radio.root.root);
dialog_data_type_enable_by_type(radio.root.root);