/// @param DataAnimKeyframe
/// @param KeyframeParameter
function animation_get_keyframe_parameter(argument0, argument1) {

    var keyframe = argument0;
    var param = argument1;

    switch (param) {
        case KeyframeParameters.TRANS_X: return keyframe.xx;
        case KeyframeParameters.TRANS_Y: return keyframe.yy;
        case KeyframeParameters.TRANS_Z: return keyframe.zz;
        case KeyframeParameters.ROT_X: return keyframe.xrot;
        case KeyframeParameters.ROT_Y: return keyframe.yrot;
        case KeyframeParameters.ROT_Z: return keyframe.zrot;
        case KeyframeParameters.SCALE_X: return keyframe.xscale;
        case KeyframeParameters.SCALE_Y: return keyframe.yscale;
        case KeyframeParameters.SCALE_Z: return keyframe.zscale;
        case KeyframeParameters.COLOR: return keyframe.color;
        case KeyframeParameters.ALPHA: return keyframe.alpha;
    }


}
