/// @param UIThing

var base_dialog = argument0.root.root.root.root;

base_dialog.selected_property.type = argument0.value;
base_dialog.changed = true;

dialog_data_type_disable(base_dialog);
dialog_data_type_enable_by_type(base_dialog);