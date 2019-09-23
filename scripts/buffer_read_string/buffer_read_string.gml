/// @param buffer
// Reads a string from a buffer of float32s. This is for backwards
// compatibility and i don't recommend using it outside of that.

var buffer = argument0;
var char;
var str = "";

do {
    char = buffer_read(buffer, T);
    str = str + chr(char);
} until (char == 0);

return str;