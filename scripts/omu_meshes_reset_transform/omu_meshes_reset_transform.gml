/// @param UIButton

var button = argument0;
var list = button.root.mesh_list;
var selection = list.selected_entries;

Stuff.mesh_ed.draw_scale = 1;
ui_input_set_value(button.root.mesh_scale, string(Stuff.mesh_ed.draw_scale));

Stuff.mesh_ed.draw_rot_x = 0;
ui_input_set_value(button.root.mesh_rot_x, string(Stuff.mesh_ed.draw_rot_x));

Stuff.mesh_ed.draw_rot_y = 0;
ui_input_set_value(button.root.mesh_rot_y, string(Stuff.mesh_ed.draw_rot_y));

Stuff.mesh_ed.draw_rot_z = 0;
ui_input_set_value(button.root.mesh_rot_z, string(Stuff.mesh_ed.draw_rot_z));