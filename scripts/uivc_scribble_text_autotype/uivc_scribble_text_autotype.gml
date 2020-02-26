/// @param UICheckbox

var checkbox = argument0;
var mode = Stuff.scribble;

mode.scribble_autotype_enabled = checkbox.value;
mode.ui.autotype_method.interactive = checkbox.value;
mode.ui.autotype_speed.interactive = checkbox.value;
mode.ui.autotype_smoothness.interactive = checkbox.value;