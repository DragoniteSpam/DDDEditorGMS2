function data_smf_optimize_mesh(mesh, samples) {
    if (samples == undefined) samples = 16;
    for (var i = 0; i < ds_list_size(mesh.submeshes); i++) {
        var submesh = mesh.submeshes[| i];
        var animation_list = submesh.vbuffer[| SMF_model.Animation];
        for (var j = 0; j < ds_list_size(animation_list) div 3; j++) {
            smf_animation_linearize(submesh.vbuffer, j, SMF_loop_quadratic, samples);
        }
    }
}