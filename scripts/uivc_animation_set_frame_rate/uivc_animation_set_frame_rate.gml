/// @param UIThing

var thing = argument0;
var animation = thing.root.root.root.active_animation;

if (animation && validate_int(thing.value)) {
    animation.frames_per_second = real(thing.value);
    thing.root.el_seconds.text = "Duration (seconds): " + string(animation.moments / animation.frames_per_second);
}