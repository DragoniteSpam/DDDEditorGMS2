/// @param DataMesh

var mesh = argument0;

for (var i = 0; i < ds_list_size(mesh.buffers); i++) {
    proto_guid_set(mesh, i, proto_guid_generate(mesh));
    ds_list_add(mesh.vbuffers, smf_model_load_from_buffer(mesh.buffers[| i]));
    data_smf_optimize_mesh(mesh, i);
}