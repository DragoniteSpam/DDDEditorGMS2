/// @param UIBitFieldOption
/// @param x
/// @param y

var bitfield = argument0;
var xx = argument1;
var yy = argument2;

var entity = bitfield.root.root.entity;
bitfield.state = entity.event_flags & (1 << bitfield.value);

ui_render_bitfield_option_text(bitfield, xx, yy);