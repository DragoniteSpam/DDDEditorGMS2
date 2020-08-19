/// @description spart_type_blend(partType, enableBlending, additive)
/// @param partType
/// @param enableBlending
/// @param additive
function spart_type_blend(argument0, argument1, argument2) {
    /*
        Toggles blending for the given particle type.
        Useful for additive effects like fire, or transparent effects like smoke.

        Script created by TheSnidr
        www.thesnidr.com
    */
    var partType = argument0;
    var enable = argument1;
    var additive = argument2;
    partType[| sPartTyp.BlendEnable] = enable;
    partType[| sPartTyp.Zwrite] = !additive;
    partType[| sPartTyp.BlendSrc] = bm_src_alpha;
    partType[| sPartTyp.BlendDst] = additive ? bm_one : bm_inv_src_alpha;


}
