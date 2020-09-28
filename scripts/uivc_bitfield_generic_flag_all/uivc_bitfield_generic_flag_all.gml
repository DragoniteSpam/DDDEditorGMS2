/// @param UIBitfield
function uivc_bitfield_generic_flag_all(argument0) {

    var bitfield = argument0;

    var base = bitfield.root;
    base.value = 0xffffffff;

    script_execute(base.onvaluechange, base);


}
