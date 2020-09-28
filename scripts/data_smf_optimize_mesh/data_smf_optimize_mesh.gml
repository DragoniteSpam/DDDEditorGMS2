/// @param DataMesh
/// @param [index]
function data_smf_optimize_mesh() {

    var mesh = argument[0];
    var index_start = (argument_count > 1) ? argument[1] : 0;
    var index_finish = (argument_count > 1) ? (argument[1] + 1) : ds_list_size(mesh.submeshes);

    for (var i = index_start; i < index_finish; i++) {
        var submesh = mesh.submeshes[| i];
        var animation_list = submesh.vbuffer[| SMF_model.Animation];
        for (var i = 0; i < ds_list_size(animation_list) div 3; i++) {
            smf_animation_linearize(submesh.vbuffer, i, SMF_loop_quadratic, 16);
        }
    }


}
