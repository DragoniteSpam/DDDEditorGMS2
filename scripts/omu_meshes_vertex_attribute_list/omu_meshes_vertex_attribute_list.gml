/// @param UIList

var list = argument0;
var format = Stuff.mesh_ed.formats[| list.root.format_index];
var index = ui_list_selection(list);
if (!(index + 1)) return;
ui_input_set_value(list.root.el_attribute_name, list.entries[| index]);
// @gml chained accessors
var attribute = format[? "attributes"];
attribute = attribute[| index];
list.root.el_attribute_type.value = attribute[? "type"];