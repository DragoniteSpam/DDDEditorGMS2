/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

// because the usual value & 0 won't do what you want it to do
bitfield.state = !get_active_tileset().passage[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y];

ui_render_bitfield_option_text(bitfield, xx, yy);