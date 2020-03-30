/// @param UIBitfieldOption

var bitfield = argument0;

Stuff.setting_selection_mask = ETypeFlags.ENTITY_ANY;
setting_set("Selection", "mask", Stuff.setting_selection_mask);
sa_process_selection();