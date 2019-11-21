/// @param UIRadioOption

var option = argument0;
var offset = 0;
var value = option.value + offset;

var base_dialog = option.root.root;

base_dialog.constant.type = value;
base_dialog.root.root.el_type.value = value;

ui_constant_data_activate(base_dialog.root.root, base_dialog.constant);