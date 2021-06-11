function animation_get_tween_color(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.color != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.color != AnimationTweens.IGNORE);
    
    var type = kf_previous ? kf_previous.tween.color : AnimationTweens.NONE;
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).color;
    var value_now = kf_current ? kf_current.color : value_default;
    var value_previous = kf_previous ? kf_previous.color : value_default;
    var value_next = kf_next ? kf_next.color : (animation.loops ? value_default : value_previous);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current) return value_now;
    
    // bgr
    var r_previous = value_previous & 0x0000ff;
    var g_previous = (value_previous & 0x00ff00) >> 8;
    var b_previous = (value_previous & 0xff0000) >> 16;
    
    var r_next = value_next & 0x0000ff;
    var g_next = (value_next & 0x00ff00) >> 8;
    var b_next = (value_next & 0xff0000) >> 16;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    var r_current = easing_easing_tween(r_previous, r_next, f, type);
    var g_current = easing_easing_tween(g_previous, g_next, f, type);
    var b_current = easing_easing_tween(b_previous, b_next, f, type);
    
    return (b_current << 16) | (g_current << 8) | r_current;
}

function animation_get_tween_alpha(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.alpha != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.alpha != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).alpha;
    var value_now = (kf_current ? kf_current.alpha : value_default) * (rel_current ? rel_current.alpha : 1);
    var value_previous = (kf_previous ? kf_previous.alpha : value_default) * (rel_previous ? rel_previous.alpha : 1);
    var value_next = (kf_next ? kf_next.alpha : (animation.loops ? value_default : value_previous)) * (rel_next ? rel_next.alpha : 1);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.alpha != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.alpha : AnimationTweens.NONE);
}

function animation_get_tween_rotate_x(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.xrot != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.xrot != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).xrot;
    var value_now = (kf_current ? kf_current.xrot : value_default) + (rel_current ? rel_current.xrot : 0);
    var value_previous = (kf_previous ? kf_previous.xrot : value_default) + (rel_previous ? rel_previous.xrot : 0);
    var value_next = (kf_next ? kf_next.xrot : (animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.xrot : 0);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.xrot != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.xrot : AnimationTweens.NONE);
}

function animation_get_tween_rotate_y(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.yrot != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.yrot != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).yrot;
    var value_now = (kf_current ? kf_current.yrot : value_default) + (rel_current ? rel_current.yrot : 0);
    var value_previous = (kf_previous ? kf_previous.yrot : value_default) + (rel_previous ? rel_previous.yrot : 0);
    var value_next = (kf_next ? kf_next.yrot : (animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.yrot : 0);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.yrot != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.yrot : AnimationTweens.NONE);
}

function animation_get_tween_rotate_z(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.zrot != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.zrot != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).zrot;
    var value_now = (kf_current ? kf_current.zrot : value_default) + (rel_current ? rel_current.zrot : 0);
    var value_previous = (kf_previous ? kf_previous.zrot : value_default) + (rel_previous ? rel_previous.zrot : 0);
    var value_next = (kf_next ? kf_next.zrot : (animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.zrot : 0);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.zrot != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.zrot : AnimationTweens.NONE);
}

function animation_get_tween_scale_x(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.xscale != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.xscale != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).xscale;
    var value_now = (kf_current ? kf_current.xscale : value_default) * (rel_current ? rel_current.xscale : 1);
    var value_previous = (kf_previous ? kf_previous.xscale : value_default) * (rel_previous ? rel_previous.xscale : 1);
    var value_next = (kf_next ? kf_next.xscale : (animation.loops ? value_default : value_previous)) * (rel_next ? rel_next.xscale : 1);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.xscale != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.xscale : AnimationTweens.NONE);
}

function animation_get_tween_scale_y(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.yscale != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.yscale != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).yscale;
    var value_now = (kf_current ? kf_current.yscale : value_default) * (rel_current ? rel_current.yscale : 1);
    var value_previous = (kf_previous ? kf_previous.yscale : value_default) * (rel_previous ? rel_previous.yscale : 1);
    var value_next = (kf_next ? kf_next.yscale : (animation.loops ? value_default : value_previous)) * (rel_next ? rel_next.yscale : 1);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.yscale != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.yscale : AnimationTweens.NONE);
}

function animation_get_tween_scale_z(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.zrot != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.zrot != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).zscale;
    var value_now = (kf_current ? kf_current.zscale : value_default) * (rel_current ? rel_current.zscale : 1);
    var value_previous = (kf_previous ? kf_previous.zscale : value_default) * (rel_previous ? rel_previous.zscale : 1);
    var value_next = (kf_next ? kf_next.zscale : (animation.loops ? value_default : value_previous)) * (rel_next ? rel_next.zscale : 1);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.zscale != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.zscale : AnimationTweens.NONE);
}

function animation_get_tween_translate_x(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.x != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.x != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    
    var value_default = animation.GetLayer(timeline_layer).xx;
    var value_now = (kf_current ? kf_current.xx : value_default) + (rel_current ? rel_current.xx : 0);
    var value_previous = (kf_previous ? kf_previous.xx : value_default) + (rel_previous ? rel_previous.xx : 0);
    var value_next = (kf_next ? kf_next.xx : (animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.xx : 0);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.x != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.x : AnimationTweens.NONE);
}

function animation_get_tween_translate_y(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.y != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.y != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).yy;
    var value_now = (kf_current ? kf_current.yy : value_default) + (rel_current ? rel_current.yy : 0);
    var value_previous = (kf_previous ? kf_previous.yy : value_default) + (rel_previous ? rel_previous.yy : 0);
    var value_next = (kf_next ? kf_next.yy : (animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.yy : 0);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.y != AnimationTweens.IGNORE) return value_now;
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.y : AnimationTweens.NONE);
}

function animation_get_tween_translate_z(animation, timeline_layer, moment) {
    var kf_current = noone;
    var kf_previous = noone;
    var kf_next = noone;
    
    kf_current = animation_get_keyframe(animation, timeline_layer, moment);
    do {
        kf_previous = animation.GetPreviousKeyframe(timeline_layer, kf_previous ? kf_previous.moment : moment);
    } until (!kf_previous || kf_previous.tween.z != AnimationTweens.IGNORE);
    do {
        kf_next = animation.GetNextKeyframe(timeline_layer, kf_next ? kf_next.moment : moment);
    } until (!kf_next || kf_next.tween.z != AnimationTweens.IGNORE);
    
    var rel_current = (kf_current && kf_current.relative > -1) ? animation.layers[kf_current.relative] : noone;
    var rel_previous = (kf_previous && kf_previous.relative > -1) ? animation.layers[kf_previous.relative] : noone;
    var rel_next = (kf_next && kf_next.relative > -1) ? animation.layers[kf_next.relative] : noone;
    
    // if no previous keyframe exists the value will always be the default (here, zero);
    // if not next keyframe exists the value will always be the previous value
    var value_default = animation.GetLayer(timeline_layer).zz;
    var value_now = (kf_current ? kf_current.zz : value_default) + (rel_current ? rel_current.zz : 0);
    var value_previous = (kf_previous ? kf_previous.zz : value_default) + (rel_previous ? rel_previous.zz : 0);
    var value_next = (kf_next ? kf_next.zz : (animation.loops ? value_default : value_previous)) + (rel_next ? rel_next.zz : 0);
    var moment_previous = kf_previous ? kf_previous.moment : 0;
    var moment_next = kf_next ? kf_next.moment : animation.moments;
    var f = normalize(moment, moment_previous, moment_next);
    
    if (kf_current && kf_current.tween.z != AnimationTweens.IGNORE) {
        return value_now;
    }
    
    // only need to check for previous keyframe because if there is no next keyframe, the "next"
    // value will be the same as previous and tweening will just output the same value anyway
    return easing_tween(value_previous, value_next, f, kf_previous ? kf_previous.tween.z : AnimationTweens.NONE);
}