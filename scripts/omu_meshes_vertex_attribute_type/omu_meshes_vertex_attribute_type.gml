/// @param UIRadioArray

var radio = argument0;
var list = radio.root.root.el_list;
var format = Stuff.mesh_ed.formats[| radio.root.root.format_index];
var index = ui_list_selection(list);
if (!(index + 1)) return;
// @gml chained accessors
var attribute = format[? "attributes"];
attribute = attribute[| index];
attribute[? "type"] = radio.value;