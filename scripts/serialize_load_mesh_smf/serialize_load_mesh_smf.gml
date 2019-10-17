/// @param DataMesh

var mesh = argument0;

mesh.vbuffer = smf_model_load_from_buffer(mesh.buffer);
data_smf_optimize_mesh(mesh);