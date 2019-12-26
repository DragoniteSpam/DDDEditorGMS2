/// @param tx
/// @param ty

var tx = argument0;
var ty = argument1;

var ts = get_active_tileset();
// refresh values that don't like to do it on their own
ui_input_set_value(Stuff.map.ui.t_p_tile_editor.element_tag, string(ts.tags[# Stuff.map.selection_fill_tile_x, Stuff.map.selection_fill_tile_y]));