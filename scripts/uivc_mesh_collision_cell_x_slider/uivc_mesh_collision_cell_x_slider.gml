/// @param UIProgressBar

var slider = argument0;
var input = slider.root.el_x_input;
slider.root.xx = round(slider.value * input.value_upper);
input.value = string(slider.root.xx);