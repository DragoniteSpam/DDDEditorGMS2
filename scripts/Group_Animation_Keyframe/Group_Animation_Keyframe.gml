function animation_set_keyframe_parameter(keyframe, param, value) {
    switch (param) {
        case KeyframeParameters.TRANS_X: keyframe.xx = value; break;
        case KeyframeParameters.TRANS_Y: keyframe.yy = value; break;
        case KeyframeParameters.TRANS_Z: keyframe.zz = value; break;
        case KeyframeParameters.ROT_X: keyframe.xrot = value; break;
        case KeyframeParameters.ROT_Y: keyframe.yrot = value; break;
        case KeyframeParameters.ROT_Z: keyframe.zrot = value; break;
        case KeyframeParameters.SCALE_X: keyframe.xscale = value; break;
        case KeyframeParameters.SCALE_Y: keyframe.yscale = value; break;
        case KeyframeParameters.SCALE_Z: keyframe.zscale = value; break;
        case KeyframeParameters.COLOR: keyframe.color = value; break;
        case KeyframeParameters.ALPHA: keyframe.alpha = value; break;
    }
}

function animation_set_keyframe_parameter_tween(keyframe, param, value) {
    switch (param) {
        case KeyframeParameters.TRANS_X: keyframe.tween.x = value; break;
        case KeyframeParameters.TRANS_Y: keyframe.tween.y = value; break;
        case KeyframeParameters.TRANS_Z: keyframe.tween.z = value; break;
        case KeyframeParameters.ROT_X: keyframe.tween.xrot = value; break;
        case KeyframeParameters.ROT_Y: keyframe.tween.yrot = value; break;
        case KeyframeParameters.ROT_Z: keyframe.tween.zrot = value; break;
        case KeyframeParameters.SCALE_X: keyframe.tween.xscale = value; break;
        case KeyframeParameters.SCALE_Y: keyframe.tween.yscale = value; break;
        case KeyframeParameters.SCALE_Z: keyframe.tween.zscale = value; break;
        case KeyframeParameters.COLOR: keyframe.tween.color = value; break;
        case KeyframeParameters.ALPHA: keyframe.tween.alpha = value; break;
    }
}