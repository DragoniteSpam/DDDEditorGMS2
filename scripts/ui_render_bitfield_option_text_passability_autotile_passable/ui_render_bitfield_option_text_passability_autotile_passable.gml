/// @param UIBitFieldOption
/// @param x
/// @param y

var ts = get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]) {
    // bitwise has its limits
    argument0.state = (ts.at_passage[Camera.selection_fill_autotile] == TILE_PASSABLE);
}

ui_render_bitfield_option_text(argument0, argument1, argument2);