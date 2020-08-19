/// @param UIBitFieldOption
/// @param x
/// @param y
function ui_render_bitfield_option_text_generic_flag_all(argument0, argument1, argument2) {

    var bitfield = argument0;
    var xx = argument1;
    var yy = argument2;

    var base = bitfield.root;
    bitfield.state = (base.value == 0xffffffff);

    ui_render_bitfield_option_text(bitfield, xx, yy);


}
