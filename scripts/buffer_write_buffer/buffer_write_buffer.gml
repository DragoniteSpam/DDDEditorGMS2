/// @param write-to
/// @param write-from

var size = buffer_get_size(argument1);
buffer_resize(argument0, buffer_get_size(argument0) + size);
buffer_copy(argument1, 0, buffer_get_size(argument1), argument0, buffer_tell(argument0));
buffer_seek(argument0, buffer_seek_relative, size);