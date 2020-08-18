/// @param string
/// @param UIInput
function validate_hex() {

	var str = argument[0];
	var input = (argument_count > 1) ? argument[1] : noone;

	if (!string_length(str)) {
	    return false;
	}

	return regex("[-+]?[0-9A-Fa-f]+", str);

	// ((\+)|(\-))?
	//      optional + or -
	// ((\d)*)
	//      0 or more digits
	// ((\.)(\d)+)?
	//      optional decimal point followed by 1 or more digits


}
