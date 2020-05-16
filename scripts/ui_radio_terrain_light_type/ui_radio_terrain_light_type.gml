/// @param UIRadioArray

var radio = argument0;
var mode = Stuff.terrain;

var light = mode.lights[| ui_list_selection(radio.root.el_light_list)];
light.type = radio.value;