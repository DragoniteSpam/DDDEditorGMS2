/// @param UIThing

var thing = argument0;
var animation = thing.root.root.root.root.root.active_animation;

// we can safely assume animation exists if we got to this point

for (var i = 0; i < ds_list_size(animation.layers); i++) {
    var timeline_layer = animation.layers[| i];
    for (var j = animation.moments; j < ds_list_size(timeline_layer.keyframes); j++) {
        var keyframe = timeline_layer.keyframes[| j];
        if (keyframe) {
            instance_activate_object(keyframe);
            instance_destroy(keyframe);
            timeline_layer.keyframes[| j] = noone;
        }
    }
}

dialog_destroy();