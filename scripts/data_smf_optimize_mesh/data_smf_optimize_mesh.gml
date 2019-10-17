/// @param DataMesh

var mesh = argument0;

for (var i = 0; (i + 3) < ds_list_size(mesh.vbuffer[| SMF_model.Animation]); i = i + 3) {
    smf_animation_linearize(mesh.vbuffer, i, SMF_loop_quadratic, 10);
}