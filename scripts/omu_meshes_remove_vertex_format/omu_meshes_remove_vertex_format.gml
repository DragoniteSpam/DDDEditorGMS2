/// @param UIButton

var button = argument0;
var mode = Stuff.mesh_ed;
var list = button.root.format_list;
var selection = ui_list_selection(list);

ds_list_delete(mode.formats, selection);
ds_list_delete(mode.format_names, selection);