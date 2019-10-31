/// @param UIColorPicker

var picker = argument0;
debug(picker.alpha);
Stuff.terrain.paint_color = picker.value | (floor(picker.alpha * 255) << 24);