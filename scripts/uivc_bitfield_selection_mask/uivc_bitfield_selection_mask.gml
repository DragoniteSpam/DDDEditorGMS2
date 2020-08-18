/// @param UIBitfieldOption
function uivc_bitfield_selection_mask(argument0) {

	var bitfield = argument0;

	Stuff.setting_selection_mask = Stuff.setting_selection_mask ^ bitfield.value;
	setting_set("Selection", "mask", Stuff.setting_selection_mask);
	sa_process_selection();


}
