/// @param UIButton

var button = argument0;
var format = Stuff.mesh_ed.formats[| button.root.format_index];

var attribute_name = "Attribute" + string(ds_list_size(button.root.el_list.entries));
ds_list_add(button.root.el_list.entries, attribute_name);
var attributes = format[? "attributes"];
var new_attribute = ds_map_create();
new_attribute[? "name"] = attribute_name;
new_attribute[? "type"] = VertexFormatData.POSITION_3D;
ds_list_add(attributes, new_attribute);
ds_list_mark_as_map(attributes, ds_list_size(attributes) - 1);