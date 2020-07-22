/// @param DataMesh

var mesh = argument0;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    mesh_mirror_y(mesh, i);
}