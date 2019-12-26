/// @param UIBitFieldOption
/// @param x
/// @param y

var option = argument0;
var xx = argument1;
var yy = argument2;

// outer border and interactivity
ui_render_bitfield_option(option, xx, yy);

var x1 = option.x + xx;
var y1 = option.y + yy;
var x2 = x1 + option.width;
var y2 = y1 + option.height;

draw_text(mean(x1, x2), mean(y1, y2), string(option.text));