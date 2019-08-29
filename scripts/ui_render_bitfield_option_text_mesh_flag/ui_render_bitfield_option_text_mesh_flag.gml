/// @param UIBitFieldOption
/// @param x
/// @param y

var thing = argument0;
var xx = argument1;
var yy = argument2;

if (data_vra_exists()) {
    var data = noone;
	stack_trace();
    thing.state = data[@ MeshArrayData.FLAGS] & thing.value;
}

ui_render_bitfield_option_text(thing, xx, yy);