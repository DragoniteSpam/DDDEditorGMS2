for (var i = 0; i < ds_list_size(keyframes); i++) {
    var keyframe = keyframes[| i];
    if (keyframe) {
        instance_activate_object(keyframe);
        instance_destroy(keyframe);
    }
}

ds_list_destroy(keyframes);