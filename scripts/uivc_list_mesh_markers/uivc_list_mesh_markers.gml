/// @param UIList
function uivc_list_mesh_markers() {

    var list = argument[0];
    var mesh = list.root.mesh;
    var selection = ds_map_to_list(list.selected_entries);

    mesh.marker = 0;
    for (var i = 0; i < ds_list_size(selection); i++) {
        mesh.marker |= (1 << selection[| i]);
    }

    ds_list_destroy(selection);


}
