/// @param UIButton

var button = argument0;
var format = Stuff.mesh_ed.formats[| button.root.format_index];
var index = ui_list_selection(button.root.el_list);
if (!(index + 1)) return;

ds_list_delete(button.root.el_list.entries, index);
var attributes = format[? "attributes"];
ds_list_delete(attributes, index);