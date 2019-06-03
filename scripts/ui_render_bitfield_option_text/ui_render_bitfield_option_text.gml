/// @description void ui_render_bitfield_option_text(UIBitFieldOption, x, y);
/// @param UIBitFieldOption
/// @param x
/// @param y

// outer border and interactivity
ui_render_bitfield_option(argument0, argument1, argument2);

var x1=argument0.x+argument1;
var y1=argument0.y+argument2;
var x2=x1+argument0.width;
var y2=y1+argument0.height;

draw_text(mean(x1, x2), mean(y1, y2), string(argument0.text));
