/// @param DataMesh
function mesh_mirror_all_y(argument0) {

    var mesh = argument0;

    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_mirror_y(mesh, i);
    }


}
