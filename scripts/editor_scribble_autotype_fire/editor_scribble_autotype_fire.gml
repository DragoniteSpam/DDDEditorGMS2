var mode = Stuff.scribble;

switch (mode.scribble_autotype_in_method) {
    case SCRIBBLE_AUTOTYPE_NONE:
        scribble_autotype_skip(mode.scribble);
        break;
    case SCRIBBLE_AUTOTYPE_PER_CHARACTER:
        scribble_autotype_fade_in(mode.scribble, mode.scribble_autotype_in_speed, mode.scribble_autotype_in_smoothness, false);
        break;
    case SCRIBBLE_AUTOTYPE_PER_LINE:
        scribble_autotype_fade_in(mode.scribble, mode.scribble_autotype_in_speed, mode.scribble_autotype_in_smoothness, true);
        break;
}