/// @param DataMesh

var mesh = argument0;

for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
    var submesh = mesh.submeshes[| i];
    submesh.vbuffer = smf_model_load_from_buffer(submesh.buffer);
    data_smf_optimize_mesh(mesh, i);
}