/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

bitfield.state = get_active_tileset().flags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y] & bitfield.value;

ui_render_bitfield_option_text(bitfield, xx, yy);