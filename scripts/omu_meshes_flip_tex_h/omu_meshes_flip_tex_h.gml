/// @param UIButton

var button = argument0;
var list = button.root.mesh_list;
var selection = list.selected_entries;

for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
    mesh_set_all_flip_tex_h(Stuff.all_meshes[| index]);
}

batch_again();