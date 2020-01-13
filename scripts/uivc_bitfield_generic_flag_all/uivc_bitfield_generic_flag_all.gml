/// @param UIBitfield

var bitfield = argument0;

var base = bitfield.root;
base.value = 0xffffffff;

script_execute(base.onvaluechange, base);