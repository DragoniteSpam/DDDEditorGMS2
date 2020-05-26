/// @param UIButton

var button = argument0;
var root_element = button.root;
var data = root_element.node.custom_data[| root_element.index];
data[| root_element.multi_index] = NULL;
dmu_dialog_commit(button);