/// @description void ui_render_bitfield_option_text_passability_autotile_solid(UIBitFieldOption, x, y);
/// @param UIBitFieldOption
/// @param x
/// @param y
// because the usual value&0 won't do what you want it to do

var ts=get_active_tileset();

if (ts.autotiles[Camera.selection_fill_autotile]!=noone) {
    argument0.state=ts.at_passage[Camera.selection_fill_autotile]==0;
}

ui_render_bitfield_option_text(argument0, argument1, argument2);
