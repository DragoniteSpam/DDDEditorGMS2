/// @param UIInput

var input = argument0;
var mode = Stuff.terrain;

var light = mode.lights[| ui_list_selection(input.root.el_light_list)];
light.y = real(input.value);