/// @param UIBitfieldOption
function uivc_bitfield_selection_mask(argument0) {

    var bitfield = argument0;

    Settings.selection.mask = Settings.selection.mask ^ bitfield.value;
    sa_process_selection();


}
