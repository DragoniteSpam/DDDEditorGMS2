/// @description boolean validate_int(string);
/// @param string

if (string_length(argument0)==0) {
    return false;
}

return regex("((\\+)|(\\-))?(\\d)+", argument0);
