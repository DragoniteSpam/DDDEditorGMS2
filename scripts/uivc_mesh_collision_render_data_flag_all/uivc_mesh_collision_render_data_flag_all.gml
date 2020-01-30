/// @param UIBitFieldOption
/// @param x
/// @param y

var option = argument0;
var xx = argument1;
var yy = argument2;

option.state = (option.root.value == 0xffffffff);

ui_render_bitfield_option_text(option, xx, yy);