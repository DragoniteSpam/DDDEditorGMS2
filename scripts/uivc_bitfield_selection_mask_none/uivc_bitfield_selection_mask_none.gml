/// @param UIBitfieldOption
function uivc_bitfield_selection_mask_none(argument0) {

    var bitfield = argument0;

    Stuff.setting_selection_mask = 0;
    setting_set("Selection", "mask", Stuff.setting_selection_mask);
    sa_process_selection();


}
