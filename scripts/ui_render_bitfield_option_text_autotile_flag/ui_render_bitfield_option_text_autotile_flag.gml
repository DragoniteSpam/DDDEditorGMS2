/// @param UIBitFieldOption
/// @param x
/// @param y

if (get_active_tileset().autotiles[Camera.selection_fill_autotile]) {
    argument0.state = get_active_tileset().at_flags[Camera.selection_fill_autotile] & argument0.value;
}

ui_render_bitfield_option_text(argument0, argument1, argument2);