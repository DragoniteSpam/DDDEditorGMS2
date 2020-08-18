function hex() {
	var str = argument[0];

	var result = 0;

	// special unicode values
	var ZERO = ord("0");
	var NINE = ord("9");
	var A = ord("A");
	var F = ord("F");

	for (var i = 1; i <= string_length(str); i++) {
	    var c = ord(string_char_at(string_upper(str), i));
	    // you could also multiply by 16 but you get more nerd points for bitshifts
	    result = result << 4;
	    // if the character is a number or letter, add the value
	    // it represents to the total
	    if (c >= ZERO && c <= NINE) {
	        result = result + (c - ZERO);
	    } else if (c >= A && c <= F) {
	        result = result + (c - A + 10);
	    // otherwise complain
	    } else {
	        show_error("bad input for hex(str): " + str, true);
	    }
	}

	return result;


}
