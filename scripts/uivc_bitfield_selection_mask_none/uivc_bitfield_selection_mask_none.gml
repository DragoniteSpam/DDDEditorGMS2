/// @param UIBitfieldOption
function uivc_bitfield_selection_mask_none(argument0) {

    var bitfield = argument0;

    Stuff.settings.selection.mask = 0;
    setting_set("Selection", "mask", Stuff.settings.selection.mask);
    sa_process_selection();


}
