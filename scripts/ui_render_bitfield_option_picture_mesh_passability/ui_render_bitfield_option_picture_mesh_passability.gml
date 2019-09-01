/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
bitfield.state = data.passage & bitfield.value;

ui_render_bitfield_option_picture(bitfield, xx, yy);