/// @param UIThing
function uivc_animation_set_moments(argument0) {

    var thing = argument0;
    var animation = thing.root.root.root.active_animation;

    if (animation) {
        animation.moments = real(thing.value);
        thing.root.el_seconds.text = "Duration (seconds): " + string(animation.moments / animation.frames_per_second);
    }


}
