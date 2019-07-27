while (!ds_priority_empty(keyframes)) {
    var keyframe = ds_priority_delete_max(keyframes);
    instance_activate_object(keyframe);
    instance_destroy(keyframe);
}

ds_priority_destroy(keyframes);