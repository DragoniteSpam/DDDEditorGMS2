/// @param UIBitfield

var bitfield = argument0;

var entity = bitfield.root.root.entity;
entity.collision_flags = entity.collision_flags ^ (1 << bitfield.value);