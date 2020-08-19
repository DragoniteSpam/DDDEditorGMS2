/// @param UIButton
function omu_mesh_rotate_axis() {

    var button = argument[0];
    var mesh = button.root.mesh;

    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_rotate_up_axis(mesh, i);
    }

    batch_again();


}
