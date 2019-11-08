/// @param UIBitFieldOption
/// @param x
/// @param y
// because the usual value & 0 won't do what you want it to do

var ts = get_active_tileset();

if (ts.autotiles[Stuff.map.selection_fill_autotile]) {
    argument0.state = ts.at_passage[Stuff.map.selection_fill_autotile] == 0;
}

ui_render_bitfield_option_text(argument0, argument1, argument2);