/// @description smf_shadowmap_create(size, intensity, angle, near, far, depthBias);
/// @param size
/// @param intensity
/// @param angle
/// @param near
/// @param far
/// @param depthBias
function smf_shadowmap_create(argument0, argument1, argument2, argument3, argument4, argument5) {
    var shadowmap = ds_list_create();
    shadowmap[| SMF_shadowmap.size] = argument0;
    shadowmap[| SMF_shadowmap.texelsize] = 1 / argument0;
    shadowmap[| SMF_shadowmap.surface] = -1;//surface_create(shadowmap[| SMF_shadowmap.size], shadowmap[| SMF_shadowmap.size]);
    shadowmap[| SMF_shadowmap.intensity] = argument1;
    shadowmap[| SMF_shadowmap.FOV] = argument2;
    shadowmap[| SMF_shadowmap.near] = argument3;
    shadowmap[| SMF_shadowmap.far] = argument4;
    shadowmap[| SMF_shadowmap.depthbias] = argument5;
    shadowmap[| SMF_shadowmap.pos] = [0, 0, 0];
    shadowmap[| SMF_shadowmap.lookat] = [0, 0, 0];
    shadowmap[| SMF_shadowmap.vmat] = SMF_MATIDENTITY;
    shadowmap[| SMF_shadowmap.pmat] = matrix_build_projection_perspective_fov(shadowmap[| SMF_shadowmap.FOV], 1, shadowmap[| SMF_shadowmap.near], shadowmap[| SMF_shadowmap.far]);
    shadowmap[| SMF_shadowmap.vpmat] = SMF_MATIDENTITY;
    return shadowmap;


}
