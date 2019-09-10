/// @param UIList
/// @param x
/// @param y

var list = argument0;
var xx = argument1;
var yy = argument2;

list.entries = list.type.is_enum ? list.type.properties : list.type.instances;

ui_render_list(list, xx, yy);