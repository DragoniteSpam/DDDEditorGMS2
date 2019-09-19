/// @param UIColorPickerInput

var picker = argument0;
var node = picker.root.node;
var index = picker.root.index;

// @todo gml update
var data_list = node.custom_data[| index];
data_list[| 0] = picker.value;