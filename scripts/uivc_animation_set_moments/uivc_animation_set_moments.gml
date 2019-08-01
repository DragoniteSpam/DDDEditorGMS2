/// @param UIThing

var thing = argument0;
var animation = thing.root.root.root.active_animation;

if (animation && validate_int(thing.value)) {
    animation.moments = real(thing.value);
    thing.root.el_seconds.text = "Duration (seconds): " + string(animation.moments / animation.frames_per_second);
    this doesnt necessarily have to wait for the user to press the Okay button before
    changing the number of moments since it doesnt actually resize the list, but there
    should definitely be a note somewhere explaining that keyframes arent deleted and
    can be recovered by expanding the timeline duration again - plus an option to
    "clear keyframes out of range" or something
}