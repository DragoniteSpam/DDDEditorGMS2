/// @param UIBitfield

var bitfield = argument0;

var data = bitfield.root.instance_data;
var tileset = get_active_tileset();
tileset.flags[# data[vec3.xx], data[vec3.yy]] = bitfield.value;