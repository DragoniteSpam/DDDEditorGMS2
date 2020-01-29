/// @param UIProgressBar

var slider = argument0;
var input = slider.root.el_y_input;
slider.root.yy = round(slider.value * input.value_upper);
input.value = string(slider.root.yy);