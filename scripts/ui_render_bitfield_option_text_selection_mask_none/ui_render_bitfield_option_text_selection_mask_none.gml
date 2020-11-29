/// @param UIBitFieldOption
/// @param x
/// @param y
function ui_render_bitfield_option_text_selection_mask_none(argument0, argument1, argument2) {

    var bitfield = argument0;
    var xx = argument1;
    var yy = argument2;

    // bitwise has its limits
    bitfield.state = (Stuff.settings.selection.mask == 0);

    ui_render_bitfield_option_text(bitfield, xx, yy);


}
