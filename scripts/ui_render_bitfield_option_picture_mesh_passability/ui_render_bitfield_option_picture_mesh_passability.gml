/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

// mesh data is stored in proto-objects represented by arrays, i have no idea why i made
// it like that but i did and now i have to deal with it
if (data_vra_exists()) {
	var data = noone;
	stack_trace();
    bitfield.state = data[@ MeshArrayData.PASSAGE] & bitfield.value;
}

ui_render_bitfield_option_picture(bitfield, xx, yy);