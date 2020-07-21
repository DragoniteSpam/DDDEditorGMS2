/// @param UIButton

var button = argument0;
var list = button.root.mesh_list;
var selection = list.selected_entries;

Stuff.mesh_ed.draw_scale = 1;
ui_input_set_value(button.root.mesh_scale, string(Stuff.mesh_ed.draw_scale));