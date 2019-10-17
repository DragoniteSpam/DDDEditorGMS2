/// @param DataMesh

var mesh = argument0;
var animation_list = mesh.vbuffer[| SMF_model.Animation];

for (var i = 0; i < ds_list_size(animation_list) div 3; i++) {
    smf_animation_linearize(mesh.vbuffer, i, SMF_loop_quadratic, 16);
}