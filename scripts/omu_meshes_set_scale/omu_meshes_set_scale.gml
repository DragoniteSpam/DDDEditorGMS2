/// @param UIButton

var button = argument0;
var list = button.root.mesh_list;
var selection = list.selected_entries;

for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
    var mesh = Stuff.all_meshes[| index];
    mesh_set_all_scale(mesh, Stuff.mesh_ed.draw_scale);
}

Stuff.mesh_ed.draw_scale = 1;
ui_input_set_value(button.root.mesh_scale, string(Stuff.mesh_ed.draw_scale));

batch_again();