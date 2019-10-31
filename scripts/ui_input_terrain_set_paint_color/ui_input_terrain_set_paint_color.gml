/// @param UIColorPicker

var picker = argument0;

// you could easily end up exporting a million materials
Stuff.terrain.paint_color = picker.value | (floor(picker.alpha * 255) << 24);