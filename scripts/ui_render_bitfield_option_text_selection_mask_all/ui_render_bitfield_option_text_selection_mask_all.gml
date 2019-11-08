/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

// bitwise has its limits
bitfield.state = (Stuff.setting_selection_mask == SELECTION_MASK_ALL);

ui_render_bitfield_option_text(bitfield, xx, yy);