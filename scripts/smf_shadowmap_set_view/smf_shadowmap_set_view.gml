/// @description smf_shadowmap_set_view(index, xfrom, yfrom, zfrom, xto, yto, zto, xup, yup, zup)
/// @param index
/// @param xfrom
/// @param yfrom
/// @param zfrom
/// @param xto
/// @param yto
/// @param zto
/// @param xup
/// @param yup
/// @param zup
function smf_shadowmap_set_view(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9) {
    var shadowmap = argument0;
    shadowmap[| SMF_shadowmap.pos] = [argument1, argument2, argument3];
    shadowmap[| SMF_shadowmap.lookat] = [argument4, argument5, argument6];
    shadowmap[| SMF_shadowmap.vmat] = matrix_build_lookat(argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9);
    shadowmap[| SMF_shadowmap.vpmat] = matrix_multiply(shadowmap[| SMF_shadowmap.vmat], shadowmap[| SMF_shadowmap.pmat]);


}
