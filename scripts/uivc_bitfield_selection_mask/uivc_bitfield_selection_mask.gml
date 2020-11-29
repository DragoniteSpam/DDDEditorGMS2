/// @param UIBitfieldOption
function uivc_bitfield_selection_mask(argument0) {

    var bitfield = argument0;

    Stuff.settings.selection.mask = Stuff.settings.selection.mask ^ bitfield.value;
    setting_set("Selection", "mask", Stuff.settings.selection.mask);
    sa_process_selection();


}
