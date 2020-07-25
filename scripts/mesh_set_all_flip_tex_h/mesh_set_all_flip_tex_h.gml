/// @param DataMesh

var mesh = argument0;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    mesh_set_flip_tex_h(mesh, i);
}