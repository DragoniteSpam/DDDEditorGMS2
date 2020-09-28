/// @description smf_shadowmap_update_start(index)
/// @param index
function smf_shadowmap_update_start(argument0) {
    var shadowmap = argument0;
    var surface = shadowmap[| SMF_shadowmap.surface];
    var size = shadowmap[| SMF_shadowmap.size];

    //Set surface target
    if !surface_exists(surface){
        surface = surface_create(size, size);
        shadowmap[| SMF_shadowmap.surface] = surface;}
    surface_set_target(surface);
    draw_clear_alpha(c_white, 1);

    //Set view and projection matrices
    matrix_set(matrix_projection, shadowmap[| SMF_shadowmap.pmat]);
    matrix_set(matrix_view, shadowmap[| SMF_shadowmap.vmat]);

    //Set shader uniforms
    var shader = sh_smf_shadowmap;
    var uni = SMF_uniforms[? shader];
    if shader_is_compiled(shader){if !SMF_shader_compiled[? shader]{smf_shader_update_uniforms(shader);}}

    shader_set(shader);
    shader_set_uniform_f(uni[SMF_uni.ShadowNear], shadowmap[| SMF_shadowmap.near]);
    shader_set_uniform_f(uni[SMF_uni.ShadowFar], shadowmap[| SMF_shadowmap.far]);

    //GPU settings
    gpu_set_cullmode(cull_noculling);


}
