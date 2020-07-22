/// @param UIInput

var input = argument0;
var list = input.root.el_list;
var format = Stuff.mesh_ed.formats[| input.root.format_index];
var index = ui_list_selection(list);
if (!(index + 1)) return;
list.entries[| index] = input.value;
// @gml chained accessors
var attribute = format[? "attributes"];
attribute = attribute[| index];
attribute[? "name"] = input.value;