/// @description String buffer_read_string(buffer);
/// @param buffer
// Reads a string from a buffer of float32s.

var char;
var str="";
do {
    char=buffer_read(argument0, T);
    str=str+chr(char);
} until(char==0);

return str;

