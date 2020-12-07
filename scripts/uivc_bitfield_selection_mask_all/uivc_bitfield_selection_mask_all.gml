/// @param UIBitfieldOption
function uivc_bitfield_selection_mask_all(argument0) {

    var bitfield = argument0;

    Settings.selection.mask = ETypeFlags.ENTITY_ANY;
    setting_set("Selection", "mask", Settings.selection.mask);
    sa_process_selection();


}
