function omu_mesh_advanced(button) {
    var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];

    if (data) {
        dialog_create_mesh_advanced(noone, data);
    }
}