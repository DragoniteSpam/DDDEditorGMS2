/// @param string

if (!string_length(argument0)) {
    return false;
}

return regex("((\\+)|(\\-))?(\\d)+", argument0);