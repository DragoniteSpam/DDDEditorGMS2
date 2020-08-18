/// @param string
function string_hash_simple(argument0) {

	var str = argument0;
	var n = 0;

	for (var i = 0; i < string_byte_length(str); i++) {
	    n += (string_byte_at(str, i) << (i % 16));
	    n |= 0x100000000;
	}

	return n;


}
