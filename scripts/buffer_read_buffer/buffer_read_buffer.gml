/// @param buffer
/// @param length

var sbuffer = buffer_create(argument1, buffer_fixed, 1);
	
buffer_copy(argument0, buffer_tell(argument0), argument1, sbuffer, 0);
buffer_seek(argument0, buffer_seek_relative, argument1);

return sbuffer;