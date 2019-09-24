/// @param string

if (!string_length(argument0)) {
    return false;
}

if (!regex("((\\+)|(\\-))?(\\d)+", argument0)) {
	return false;
}

var value = real(argument0);

return (value * Stuff.active_map.yy * Stuff.active_map.xx) <= MAP_VOLUME_LIMIT;