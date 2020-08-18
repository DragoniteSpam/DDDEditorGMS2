/// @param string
/// @param UIInput
function validate_int_map_size_z() {

	var str = argument[0];
	var input = argument[1];

	if (!validate_int(str, input)) {
	    return false;
	}

	var value = real(str);

	return (value * Stuff.map.active_map.yy * Stuff.map.active_map.xx) <= MAP_VOLUME_LIMIT;


}
