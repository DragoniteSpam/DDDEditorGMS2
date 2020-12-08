/// @param UIBitfieldOption
function uivc_bitfield_selection_mask_none(argument0) {

    var bitfield = argument0;

    Settings.selection.mask = 0;
    sa_process_selection();


}
