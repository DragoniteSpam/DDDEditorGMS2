/// @param UIBitFieldOption
/// @param x
/// @param y

var option = argument0;
var xx = argument1;
var yy = argument2;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
option.state = (data.passage == TILE_PASSABLE);

ui_render_bitfield_option_text(option, xx, yy);