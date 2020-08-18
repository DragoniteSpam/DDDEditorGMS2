/// @param buffer
function buffer_read_string(argument0) {
	// Reads a string from a buffer of float32s. This is for backwards
	// compatibility and i don't recommend using it outside of that.

	var buffer = argument0;
	var char;
	var str = "";

	do {
	    char = buffer_read(buffer, buffer_f32);
	    str = str + chr(char);
	} until (char == 0);

	return str;


}
