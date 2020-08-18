/// @param UIBitfield
function uivc_mesh_set_flags(argument0) {

	var bitfield = argument0;

	var data = bitfield.root.instance_data;
	data.flags = bitfield.value;


}
