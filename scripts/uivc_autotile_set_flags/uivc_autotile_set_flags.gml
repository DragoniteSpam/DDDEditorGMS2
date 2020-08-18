/// @param UIBitfield
function uivc_autotile_set_flags(argument0) {

	var bitfield = argument0;

	var data = bitfield.root.instance_data;
	data.flags = bitfield.value;


}
