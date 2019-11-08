/// @param UIButton

var button = argument0;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

if (data) {
    dialog_create_mesh_advanced(noone, data);
}