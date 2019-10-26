/// @param string
/// @param UIInput

var str = argument[0];
var input = argument[1];

if (!string_length(str)) {
    return false;
}

return regex("((\\+)|(\\-))?(\\d)+", str);