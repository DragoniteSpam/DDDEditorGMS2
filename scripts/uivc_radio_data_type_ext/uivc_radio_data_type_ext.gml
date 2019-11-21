/// @param UIRadio

var radio = argument0;
var offset = 0;
var value = radio.value + offset;

var base_dialog = radio.root.root.root.root;

base_dialog.selected_property.type = value;
base_dialog.changed = true;

dialog_data_type_disable(base_dialog);
dialog_data_type_enable_by_type(base_dialog);