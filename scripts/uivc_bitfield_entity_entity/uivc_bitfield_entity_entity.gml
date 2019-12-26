/// @param UIBitfield

var bitfield = argument0;

var entity = bitfield.root.root.entity;
entity.event_flags = entity.event_flags ^ (1 << bitfield.value);