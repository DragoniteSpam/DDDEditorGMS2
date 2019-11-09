/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

bitfield.state = get_active_tileset().passage[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y] & bitfield.value;

ui_render_bitfield_option_picture(bitfield, xx, yy);