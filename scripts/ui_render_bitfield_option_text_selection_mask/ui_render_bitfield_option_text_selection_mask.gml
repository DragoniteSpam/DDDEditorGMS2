/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

bitfield.state = Stuff.setting_selection_mask & bitfield.value;

ui_render_bitfield_option_text(bitfield, xx, yy);