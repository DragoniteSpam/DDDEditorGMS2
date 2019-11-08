/// @description void ui_render_bitfield_option_text_passability_tile_solid(UIBitFieldOption, x, y);
/// @param UIBitFieldOption
/// @param x
/// @param y
// because the usual value&0 won't do what you want it to do

argument0.state=get_active_tileset().passage[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y]==0;

ui_render_bitfield_option_text(argument0, argument1, argument2);
