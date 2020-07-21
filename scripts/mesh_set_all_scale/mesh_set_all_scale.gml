/// @param DataMesh
/// @param scale

var mesh = argument0;
var scale = argument1;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    mesh_set_scale(mesh, i, scale);
}