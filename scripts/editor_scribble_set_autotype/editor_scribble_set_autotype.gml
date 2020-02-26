var mode = Stuff.scribble;

if (mode.scribble_autotype_enabled) {
    scribble_autotype_fade_in(mode.scribble, mode.scribble_autotype_method, mode.scribble_autotype_speed, mode.scribble_autotype_smoothness);
} else {
    scribble_autotype_fade_in(mode.scribble, SCRIBBLE_AUTOTYPE_NONE, mode.scribble_autotype_speed, mode.scribble_autotype_smoothness);
}