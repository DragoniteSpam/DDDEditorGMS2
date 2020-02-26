/// @param UIInput

var input = argument0;
var mode = Stuff.scribble;

mode.scribble_autotype_smoothness = real(input.value);
editor_scribble_set_autotype();