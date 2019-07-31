/// @param DataAnimKeyframe
/// @param KeyframeParameter
/// @param value

var keyframe = argument0;
var param = argument1;
var value = argument2;

switch (param) {
    case KeyframeParameters.TRANS_X:
        keyframe.xx = value;
        break;
    case KeyframeParameters.TRANS_Y:
        keyframe.yy = value;
        break;
    case KeyframeParameters.TRANS_Z:
        keyframe.zz = value;
        break;
    case KeyframeParameters.ROT_X:
        keyframe.xrot = value;
        break;
    case KeyframeParameters.ROT_Y:
        keyframe.yrot = value;
        break;
    case KeyframeParameters.ROT_Z:
        keyframe.zrot = value;
        break;
    case KeyframeParameters.SCALE_X:
        keyframe.xscale = value;
        break;
    case KeyframeParameters.SCALE_Y:
        keyframe.yscale = value;
        break;
    case KeyframeParameters.SCALE_Z:
        keyframe.zscale = value;
        break;
    case KeyframeParameters.COLOR:
        keyframe.color = value;
        break;
    case KeyframeParameters.ALPHA:
        keyframe.alpha = value;
        break;
}