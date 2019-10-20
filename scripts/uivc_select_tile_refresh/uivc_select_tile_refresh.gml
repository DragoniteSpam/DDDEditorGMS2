/// @param tx
/// @param ty

var tx = argument0;
var ty = argument1;

var ts = get_active_tileset();
// refresh values that don't like to do it on their own
ui_input_set_value(Camera.ui.t_p_tile_editor.element_priority, string(ts.priority[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]));
ui_input_set_value(Camera.ui.t_p_tile_editor.element_tag, string(ts.tags[# Camera.selection_fill_tile_x, Camera.selection_fill_tile_y]));