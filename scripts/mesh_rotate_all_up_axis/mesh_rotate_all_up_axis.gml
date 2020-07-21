/// @param DataMesh

var mesh = argument0;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    mesh_rotate_up_axis(mesh, i);
}