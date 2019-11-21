/// @param UIColorPicker

var picker = argument0;
var entity = picker.root.entity;
var selection = ui_list_selection(picker.root.el_list);
var data = entity.generic_data[| selection];

data.value_color = picker.value;