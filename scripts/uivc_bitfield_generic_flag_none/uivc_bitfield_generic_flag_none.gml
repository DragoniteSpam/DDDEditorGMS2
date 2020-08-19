/// @param UIBitfield
function uivc_bitfield_generic_flag_none(argument0) {

    var bitfield = argument0;

    var base = bitfield.root;
    base.value = 0;

    script_execute(base.onvaluechange, base);


}
