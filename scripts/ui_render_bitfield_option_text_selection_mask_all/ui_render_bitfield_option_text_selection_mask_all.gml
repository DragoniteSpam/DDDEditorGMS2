/// @param UIBitFieldOption
/// @param x
/// @param y
function ui_render_bitfield_option_text_selection_mask_all(argument0, argument1, argument2) {

    var bitfield = argument0;
    var xx = argument1;
    var yy = argument2;

    // bitwise has its limits
    bitfield.state = (Stuff.setting_selection_mask == ETypeFlags.ENTITY_ANY);

    ui_render_bitfield_option_text(bitfield, xx, yy);


}
