/// @param UIProgressBar

var slider = argument0;
var input = slider.root.el_z_input;
slider.root.zz = round(slider.value * input.value_upper);
input.value = string(slider.root.zz);