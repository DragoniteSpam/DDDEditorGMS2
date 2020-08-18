/// @param value
function decimal(argument0) {

	// i tried finding a regex that would do this but none of them would
	// properly handle things like 15.000
	var value = string_format(argument0, 1, 10);

	if (string_count(".", value) == 0) {
	    return value;
	}

	while (string_char_at(value, string_length(value)) == "0") {
	    value = string_copy(value, 1, string_length(value) - 1);
	}

	if (string_char_at(value, string_length(value)) == ".") {
	    return string_copy(value, 1, string_length(value) - 1);
	}

	return value;


}
