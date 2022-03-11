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