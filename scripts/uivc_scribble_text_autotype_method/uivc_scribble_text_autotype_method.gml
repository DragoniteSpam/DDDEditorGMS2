/// @param UIRadioArrayOption

var radio = argument0;
var mode = Stuff.scribble;

switch (radio.value) {
    case 0: mode.scribble_autotype_method = SCRIBBLE_AUTOTYPE_PER_CHARACTER; break;
    case 1: mode.scribble_autotype_method = SCRIBBLE_AUTOTYPE_PER_LINE; break;
}

editor_scribble_set_autotype();