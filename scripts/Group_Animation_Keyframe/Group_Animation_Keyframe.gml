function animation_add_keyframe(animation, timeline_layer, moment, auto_fill) {
    var inst_layer = animation_get_layer(animation, timeline_layer);
    if (auto_fill == undefined) auto_fill = false;
    var keyframe = instance_create_depth(0, 0, 0, DataAnimKeyframe);
    
    if (auto_fill) {
        // you need to set the values before adding the keyframe to the timeline, because
        // if the keyframe is already in the timeline it'll just get its own (zeroed) values
        // when you try to get the current value at the moment
        keyframe.xx = animation_get_tween_translate_x(animation, timeline_layer, moment);
        keyframe.yy = animation_get_tween_translate_y(animation, timeline_layer, moment);
        keyframe.zz = animation_get_tween_translate_z(animation, timeline_layer, moment);
        keyframe.xrot = animation_get_tween_rotate_x(animation, timeline_layer, moment);
        keyframe.yrot = animation_get_tween_rotate_y(animation, timeline_layer, moment);
        keyframe.zrot = animation_get_tween_rotate_z(animation, timeline_layer, moment);
        keyframe.xscale = animation_get_tween_scale_x(animation, timeline_layer, moment);
        keyframe.yscale = animation_get_tween_scale_y(animation, timeline_layer, moment);
        keyframe.zscale = animation_get_tween_scale_z(animation, timeline_layer, moment);
        keyframe.color = animation_get_tween_color(animation, timeline_layer, moment);
        keyframe.alpha = animation_get_tween_alpha(animation, timeline_layer, moment);
    }
    
    keyframe.moment = moment;
    keyframe.timeline_layer = timeline_layer;
    keyframe.relative = timeline_layer;
    inst_layer.keyframes[| moment] = keyframe;
    
    return keyframe;
}

function animation_get_keyframe_parameter(keyframe, param) {
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

function animation_get_keyframe(animation, timeline_layer, moment) {
    var timeline_layer = animation_get_layer(animation, timeline_layer);
    if (timeline_layer) {
        var keyframe = timeline_layer.keyframes[| moment];
        return keyframe ? keyframe : noone;
    }
    
    return noone;
}

function animation_get_keyframe_has_tween(keyframe) {
    // just checks to see if *any* of the tweens it uses are typed - it doesn't really
    // care which ones they are
    if (keyframe.tween_xx != AnimationTweens.NONE && keyframe.tween_xx != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_yy != AnimationTweens.NONE && keyframe.tween_yy != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_zz != AnimationTweens.NONE && keyframe.tween_zz != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_xrot != AnimationTweens.NONE && keyframe.tween_xrot != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_yrot != AnimationTweens.NONE && keyframe.tween_yrot != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_zrot != AnimationTweens.NONE && keyframe.tween_zrot != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_xscale != AnimationTweens.NONE && keyframe.tween_xscale != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_yscale != AnimationTweens.NONE && keyframe.tween_yscale != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_zscale != AnimationTweens.NONE && keyframe.tween_zscale != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_color != AnimationTweens.NONE && keyframe.tween_color != AnimationTweens.IGNORE) return true;
    if (keyframe.tween_alpha != AnimationTweens.NONE && keyframe.tween_alpha != AnimationTweens.IGNORE) return true;
    return false;
}

function animation_get_keyframe_parameter_tween(keyframe, param) {
    switch (param) {
        case KeyframeParameters.TRANS_X: return keyframe.tween_xx;
        case KeyframeParameters.TRANS_Y: return keyframe.tween_yy;
        case KeyframeParameters.TRANS_Z: return keyframe.tween_zz;
        case KeyframeParameters.ROT_X: return keyframe.tween_xrot;
        case KeyframeParameters.ROT_Y: return keyframe.tween_yrot;
        case KeyframeParameters.ROT_Z: return keyframe.tween_zrot;
        case KeyframeParameters.SCALE_X: return keyframe.tween_xscale;
        case KeyframeParameters.SCALE_Y: return keyframe.tween_yscale;
        case KeyframeParameters.SCALE_Z: return keyframe.tween_zscale;
        case KeyframeParameters.COLOR: return keyframe.tween_color;
        case KeyframeParameters.ALPHA: return keyframe.tween_alpha;
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
        case KeyframeParameters.TRANS_X: keyframe.tween_xx = value; break;
        case KeyframeParameters.TRANS_Y: keyframe.tween_yy = value; break;
        case KeyframeParameters.TRANS_Z: keyframe.tween_zz = value; break;
        case KeyframeParameters.ROT_X: keyframe.tween_xrot = value; break;
        case KeyframeParameters.ROT_Y: keyframe.tween_yrot = value; break;
        case KeyframeParameters.ROT_Z: keyframe.tween_zrot = value; break;
        case KeyframeParameters.SCALE_X: keyframe.tween_xscale = value; break;
        case KeyframeParameters.SCALE_Y: keyframe.tween_yscale = value; break;
        case KeyframeParameters.SCALE_Z: keyframe.tween_zscale = value; break;
        case KeyframeParameters.COLOR: keyframe.tween_color = value; break;
        case KeyframeParameters.ALPHA: keyframe.tween_alpha = value; break;
    }
}

function animation_set_keyframe_position(animation, keyframe, layer, moment) {
    var inst_layer = animation_get_layer(animation, layer);
    inst_layer.keyframes[| keyframe.moment] = noone;
    keyframe.moment = moment;
    inst_layer.keyframes[| moment] = keyframe;
    return keyframe;
}