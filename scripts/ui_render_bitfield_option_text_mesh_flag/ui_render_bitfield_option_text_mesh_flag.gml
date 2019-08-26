/// @param UIBitFieldOption
/// @param x
/// @param y

var thing = argument0;
var xx = argument1;
var yy = argument2;

if (data_vra_exists()) {
    var data = Stuff.vra_data[? Stuff.all_mesh_names[| Camera.selection_fill_mesh]];
    thing.state = data[@ MeshArrayData.FLAGS] & thing.value;
}

ui_render_bitfield_option_text(thing, xx, yy);