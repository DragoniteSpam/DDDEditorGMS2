/// @param string
/// @param UIInput

var str = argument[0];
var input = argument[1];

if (str == "") {
    return true;
}

return validate_string_internal_name(str, input);