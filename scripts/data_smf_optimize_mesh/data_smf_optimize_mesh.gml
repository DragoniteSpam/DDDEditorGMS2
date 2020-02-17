/// @param DataMesh
/// @param [index]

var mesh = argument[0];
var index_start = (argument_count > 1) ? argument[1] : 0;
var index_finish = (argument_count > 1) ? (argument[1] + 1) : ds_list_size(mesh.vbuffers);

for (var i = index_start; i < index_finish; i++) {
    var smf = mesh.vbuffers[| i];
    var animation_list = smf[| SMF_model.Animation];
    for (var i = 0; i < ds_list_size(animation_list) div 3; i++) {
        smf_animation_linearize(smf, i, SMF_loop_quadratic, 16);
    }
}