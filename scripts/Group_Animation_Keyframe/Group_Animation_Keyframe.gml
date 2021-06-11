function animation_get_keyframe_has_tween(keyframe) {
    // just checks to see if *any* of the tweens it uses are typed - it doesn't really
    // care which ones they are
    if (keyframe.tween.x != AnimationTweens.NONE && keyframe.tween.x != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.y != AnimationTweens.NONE && keyframe.tween.y != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.z != AnimationTweens.NONE && keyframe.tween.z != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.xrot != AnimationTweens.NONE && keyframe.tween.xrot != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.yrot != AnimationTweens.NONE && keyframe.tween.yrot != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.zrot != AnimationTweens.NONE && keyframe.tween.zrot != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.xscale != AnimationTweens.NONE && keyframe.tween.xscale != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.yscale != AnimationTweens.NONE && keyframe.tween.yscale != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.zscale != AnimationTweens.NONE && keyframe.tween.zscale != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.color != AnimationTweens.NONE && keyframe.tween.color != AnimationTweens.IGNORE) return true;
    if (keyframe.tween.alpha != AnimationTweens.NONE && keyframe.tween.alpha != AnimationTweens.IGNORE) return true;
    return false;
}

function animation_get_keyframe_parameter_tween(keyframe, param) {
    switch (param) {
        case KeyframeParameters.TRANS_X: return keyframe.tween.x;
        case KeyframeParameters.TRANS_Y: return keyframe.tween.y;
        case KeyframeParameters.TRANS_Z: return keyframe.tween.z;
        case KeyframeParameters.ROT_X: return keyframe.tween.xrot;
        case KeyframeParameters.ROT_Y: return keyframe.tween.yrot;
        case KeyframeParameters.ROT_Z: return keyframe.tween.zrot;
        case KeyframeParameters.SCALE_X: return keyframe.tween.xscale;
        case KeyframeParameters.SCALE_Y: return keyframe.tween.yscale;
        case KeyframeParameters.SCALE_Z: return keyframe.tween.zscale;
        case KeyframeParameters.COLOR: return keyframe.tween.color;
        case KeyframeParameters.ALPHA: return keyframe.tween.alpha;
    }
}

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