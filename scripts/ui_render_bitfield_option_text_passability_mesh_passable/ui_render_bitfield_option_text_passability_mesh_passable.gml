/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

var data = Stuff.all_meshes[| Stuff.map.selection_fill_mesh];
bitfield.interactive = (data && true);

if (data) {
    bitfield.state = (data.passage == TILE_PASSABLE);
}

ui_render_bitfield_option_text(bitfield, xx, yy);