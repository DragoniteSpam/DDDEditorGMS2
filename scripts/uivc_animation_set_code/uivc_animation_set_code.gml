/// @param UIThing

var thing = argument0;
var animation = thing.root.root.root.active_animation;

if (animation) {
    animation.code = thing.value;
}