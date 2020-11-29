/// @param UIBitfieldOption
function uivc_bitfield_selection_mask_all(argument0) {

    var bitfield = argument0;

    Stuff.settings.selection.mask = ETypeFlags.ENTITY_ANY;
    setting_set("Selection", "mask", Stuff.settings.selection.mask);
    sa_process_selection();


}
