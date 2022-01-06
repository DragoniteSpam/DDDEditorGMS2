function ui_value_real(str) {
    return real(str);
}

function ui_value_string(str) {
    return true;
}

function validate_double(str) {
    try {
        real(str);
    } catch (e) {
        return false;
    }
    return true;
}

function validate_hex(str) {
    try {
        emu_hex(str);
    } catch (e) {
        return false;
    }
    return true;
}

function validate_int(str) {
	if (string_count(".", str) > 0) return false;
	if (string_count("e", str) > 0) return false;
    try {
        real(str);
    } catch (e) {
        return false;
    }
    return true;
}

function validate_int_create_map_size(str, input) {
    var str_x = input.root.el_x.value;
    var str_y = input.root.el_y.value;
    var str_z = input.root.el_z.value;
    if (!validate_int(str_x)) return false;
    if (!validate_int(str_y)) return false;
    if (!validate_int(str_z)) return false;
    var value_x = real(str_x);
    var value_y = real(str_y);
    var value_z = real(str_z);
    var volume = (value_x * value_y * value_z);
    return is_clamped(volume, 1, MAP_VOLUME_LIMIT);
}

function validate_int_map_size_x(str) {
    if (!validate_int(str)) return false;
    return (real(str) * Stuff.map.active_map.yy * Stuff.map.active_map.zz) <= MAP_VOLUME_LIMIT;
}

function validate_int_map_size_y(str) {
    if (!validate_int(str)) return false;
    return (real(str) * Stuff.map.active_map.xx * Stuff.map.active_map.zz) <= MAP_VOLUME_LIMIT;
}

function validate_int_map_size_z(str) {
    if (!validate_int(str)) return false;
    return (real(str) * Stuff.map.active_map.yy * Stuff.map.active_map.xx) <= MAP_VOLUME_LIMIT;
}

function validate_string(str) {
    return true;
}

function validate_string_event_name(str, input) {
	static other_valid_characters = ["_", "+", "$"];
	
    var str_len = string_length(str);
    if (str_len == 0) return false;
    
    var str_len_valid = string_length(string_lettersdigits(str));
    for (var i = 0, n = array_length(other_valid_characters); i < n; i++) {
        str_len_valid += string_count(other_valid_characters[i], str);
    }
    
    if (str_len_valid != str_len) return false;
    
    if (input) {
        var node = input.root.node;
        if (node.event.name_map[$ str] && node.event.name_map[$ str] != node) {
            return false;
        }
    }
    
    return true;
}

function validate_string_internal_name(str) {
	static other_valid_characters = ["_"];
	
    var str_len = string_length(str);
    if (str_len == 0) return false;
    
    var str_len_valid = string_length(string_lettersdigits(str));
    for (var i = 0, n = array_length(other_valid_characters); i < n; i++) {
        str_len_valid += string_count(other_valid_characters[i], str);
    }
    
    return (str_len_valid == str_len);
}

function validate_string_internal_name_or_empty(str) {
    if (str == "") return true;
    return validate_string_internal_name(str);
}