/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

// bitwise has its limits
bitfield.state = get_active_tileset().passage[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y] == TILE_PASSABLE;

ui_render_bitfield_option_text(bitfield, xx, yy);