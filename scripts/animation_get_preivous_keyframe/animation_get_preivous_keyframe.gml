function animation_get_preivous_keyframe(animation, timeline_layer, moment) {
    for (var i = moment - 1; i >= 0; i--) {
        var keyframe = animation_get_keyframe(animation, timeline_layer, i);
        if (keyframe) {
            // @gml update lightweight objects maybe?
            return keyframe;
        }
    }
    
    return noone;
}