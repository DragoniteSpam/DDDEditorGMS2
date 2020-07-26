/// @param UIButton

var button = argument0;
var selection = button.root.selection;

for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
    var mesh = Stuff.all_meshes[| index];
    mesh_set_normals_zero(mesh);
}

batch_again();