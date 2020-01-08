/// @param buffer
/// @param length

var original = argument0;
var length = argument1;

var sbuffer = buffer_create(length, buffer_fixed, 1);
    
buffer_copy(original, buffer_tell(original), length, sbuffer, 0);
buffer_seek(original, buffer_seek_relative, length);

return sbuffer;