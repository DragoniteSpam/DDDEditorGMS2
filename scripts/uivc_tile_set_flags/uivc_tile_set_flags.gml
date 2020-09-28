/// @param UIBitfield
function uivc_tile_set_flags(argument0) {

    var bitfield = argument0;

    var data = bitfield.root.instance_data;
    var ts = get_active_tileset();
    ts.flags[# data[vec3.xx], data[vec3.yy]] = bitfield.value;


}
