/// @param buffer
/// @param string

// Writes a string from a buffer of float32s. This is for backwards
// compatibility and i don't recommend using it outside of that.

var buffer = argument0;
var str = argument1;

for (var i = 1; i <= string_length(str); i++) {
    buffer_write(buffer, buffer_f32, ord(string_char_at(str, i)));
}

buffer_write(buffer, buffer_f32, 0);