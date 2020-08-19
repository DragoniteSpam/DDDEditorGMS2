/// @param UIButton
function omu_meshes_flip_tex_v(argument0) {

    var button = argument0;
    var list = button.root.mesh_list;
    var selection = list.selected_entries;

    for (var index = ds_map_find_first(selection); index != undefined; index = ds_map_find_next(selection, index)) {
        mesh_set_all_flip_tex_v(Stuff.all_meshes[| index]);
    }

    batch_again();


}
