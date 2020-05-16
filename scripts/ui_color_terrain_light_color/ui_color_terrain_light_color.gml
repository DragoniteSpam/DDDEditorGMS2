/// @param UIColorPicker

var color = argument0;
var mode = Stuff.terrain;

var light = mode.lights[| ui_list_selection(color.root.el_light_list)];
light.type = color.value;