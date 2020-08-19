/// @param UIButton
function omu_meshes_mirror_x(argument0) {

    var button = argument0;
    var list = button.root.mesh_list;
    var selection = list.selected_entries;

    for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
        var mesh = Stuff.all_meshes[| index];
        mesh_mirror_all_x(mesh);
    }

    batch_again();


}
