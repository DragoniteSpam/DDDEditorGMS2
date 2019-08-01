/// @param UIThing

var thing = argument0;
var animation = thing.root.root.root.active_animation;

// we can safely assume animation exists if we got to this point
var n = 0;
for (var i = 0; i < ds_list_size(animation.layers); i++) {
    var timeline_layer = animation.layers[| i];
    for (var j = animation.moments; j < ds_list_size(timeline_layer.keyframes); j++) {
        if (timeline_layer.keyframes[| j]) {
            n++;
        }
    }
}
if (n == 0) {
    dialog_create_notice(thing, "There are no out-of-bounds keyframes in this animation. You don't have to worry!");
} else {
    var msg = (n > 1) ? "There are " + string(n) + " out-of-bounds keyframes in this animation. Would you like to get rid of them?" : "There is 1 out-of-bounds keyframe in this animation. Would you like to get rid of it?";
    dialog_create_yes_or_no(thing, msg, omu_animation_clear_keyframes_execute);
}