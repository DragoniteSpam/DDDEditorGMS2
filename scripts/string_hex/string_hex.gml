/// @param value
/// @param [pad=0]
function string_hex() {

	var value = argument[0];
	var padding = (argument_count > 1) ? argument[1] : 0;

	var s = sign(value);
	var v = abs(value);

	var output = "";

	while (v > 0)  {
	    var c  = v & 0xf;
	    output = chr(c + ((c < 10) ? 48 : 55)) + output;
	    v = v >> 4;
	}

	if (string_length(output) == 0) {
	    output = "0";
	}

	return ((s < 0) ? "-" : "") + string_pad(output, "0", padding);


}
