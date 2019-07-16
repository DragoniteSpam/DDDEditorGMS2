/// @param UIBitFieldOption
/// @param x
/// @param y

var ts = get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]) {
    argument0.state = ts.at_passage[Camera.selection_fill_autotile] & argument0.value;
}

ui_render_bitfield_option_picture(argument0, argument1, argument2);