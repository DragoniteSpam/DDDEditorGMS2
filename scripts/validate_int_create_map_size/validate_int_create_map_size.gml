/// @param string
/// @param UIInput
function validate_int_create_map_size() {

	var str = argument[0];
	var input = argument[1];

	var str_x = input.root.el_x.value;
	var str_y = input.root.el_y.value;
	var str_z = input.root.el_z.value;

	if (!validate_int(str_x, input)) {
	    return false;
	}

	if (!validate_int(str_y, input)) {
	    return false;
	}

	if (!validate_int(str_z, input)) {
	    return false;
	}

	var value_x = real(str_x);
	var value_y = real(str_y);
	var value_z = real(str_z);
	var volume = (value_x * value_y * value_z);

	return is_clamped(volume, 1, MAP_VOLUME_LIMIT);


}
