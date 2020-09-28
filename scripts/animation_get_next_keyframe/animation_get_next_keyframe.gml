function animation_get_next_keyframe(animation, timeline_layer, moment) {    
    for (var i = moment + 1; i < animation.moments; i++) {
        var keyframe = animation_get_keyframe(animation, timeline_layer, i);
        if (keyframe) {
            // @gml update lightweight objects maybe?
            return keyframe;
        }
    }
    
    return noone;
}