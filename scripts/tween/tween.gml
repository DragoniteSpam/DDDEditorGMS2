/// @param v0
/// @param v1
/// @param f
/// @param tween-type

var v0 = argument0;
var v1 = argument1;
var f = argument2;
var type = argument3;

switch (type) {
    case AnimationTweens.IGNORE:
    case AnimationTweens.NONE:
        return v0;
    case AnimationTweens.LINEAR:
        return lerp(v0, v1, f);
    case AnimationTweens.EASE_IO_SINE:
        return ease_sine_io(v0, v1, f);
}