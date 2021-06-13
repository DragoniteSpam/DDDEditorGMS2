function serialize_load_mesh_smf(mesh) {
    for (var i = 0; i < array_length(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[i];
        submesh.vbuffer = smf_model_load_from_buffer(submesh.buffer);
    }
    data_smf_optimize_mesh(mesh);
}