function regex(expression, str) {
    regex_setexpression(expression);
    regex_setinput(str);
    return regex_match();
}

function ui_value_real(input) {
    return real(input);
}

function ui_value_string(input) {
    return input;
}

function validate_code(expression, input) {
    // @todo validate the Lua
    return true;
}

function validate_double(str, input) {
    if (string_length(str) == 0) return false;
    return regex("[-+]?[0-9]*\.?[0-9]+", str);
}

function validate_hex(str, input) {
    if (string_length(str) == 0) return false;
    return regex("[-+]?[0-9A-Fa-f]+", str);
}

function validate_int(str, input) {
    if (string_length(str) == 0) return false;
    return regex("((\\+)|(\\-))?(\\d)+", str);

}

function validate_int_create_map_size(str, input) {
    var str_x = input.root.el_x.value;
    var str_y = input.root.el_y.value;
    var str_z = input.root.el_z.value;
    if (!validate_int(str_x, input)) return false;
    if (!validate_int(str_y, input)) return false;
    if (!validate_int(str_z, input)) return false;
    var value_x = real(str_x);
    var value_y = real(str_y);
    var value_z = real(str_z);
    var volume = (value_x * value_y * value_z);
    return is_clamped(volume, 1, MAP_VOLUME_LIMIT);
}

function validate_int_map_size_x(str, input) {
    if (!validate_int(str, input)) return false;
    return (real(str) * Stuff.map.active_map.yy * Stuff.map.active_map.zz) <= MAP_VOLUME_LIMIT;
}

function validate_int_map_size_y(str, input) {
    if (!validate_int(str, input)) return false;
    return (real(str) * Stuff.map.active_map.xx * Stuff.map.active_map.zz) <= MAP_VOLUME_LIMIT;
}

function validate_int_map_size_z(str, input) {
    if (!validate_int(str, input)) return false;
    return (real(str) * Stuff.map.active_map.yy * Stuff.map.active_map.xx) <= MAP_VOLUME_LIMIT;
}

function validate_string(str) {
    return true;
}

function validate_string_event_name(str, input) {
    if (string_length(str) == 0) return false;
    if (!regex("[A-Za-z0-9_\+\$]+", str)) return false;
    
    if (input) {
        var node = input.root.node;
        if (node.event.name_map[? str] && node.event.name_map[? str] != node) {
            return false;
        }
    }
    
    return true;
}

function validate_string_internal_name(str, input) {
    // characters must be save to use as a file name; to keep things simple we'll
    // use the A-Za-z0-9\_ pattern of variable names, although we don't care if
    // they start with a digit in this case
    return regex("[A-Za-z0-9_]+", str);
}

function validate_string_internal_name_or_empty(str, input) {
    if (str == "") return true;
    return validate_string_internal_name(str, input);
}