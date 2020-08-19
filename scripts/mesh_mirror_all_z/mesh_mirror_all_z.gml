/// @param DataMesh
function mesh_mirror_all_z(argument0) {

    var mesh = argument0;

    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        mesh_mirror_z(mesh, i);
    }


}
