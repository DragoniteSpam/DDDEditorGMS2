/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

var data = Stuff.all_meshes[| Camera.selection_fill_mesh];
bitfield.interactive = (data && true);

if (data) {
    bitfield.state = (data.passage == 0);
}

ui_render_bitfield_option_text(bitfield, xx, yy);