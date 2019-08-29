/// @param UIBitFieldOption
/// @param x
/// @param y

var option = argument0;
var xx = argument1;
var yy = argument2;

if (data_vra_exists()) {
    var data = noone;
	stack_trace();
    option.state = (data[@ MeshArrayData.PASSAGE] == TILE_PASSABLE);
}

ui_render_bitfield_option_text(option, xx, yy);