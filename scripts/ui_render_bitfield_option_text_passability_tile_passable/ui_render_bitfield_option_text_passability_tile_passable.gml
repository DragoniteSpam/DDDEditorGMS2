/// @param UIBitFieldOption
/// @param x
/// @param y

// bitwise has its limits
argument0.state = get_active_tileset().passage[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y] == TILE_PASSABLE;

ui_render_bitfield_option_text(argument0, argument1, argument2);