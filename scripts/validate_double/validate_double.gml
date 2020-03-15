/// @param string
/// @param UIInput

var str = argument[0];
var input = (argument_count > 1 && argument[1] != undefined) ? argument[1] : noone;

if (!string_length(str)) {
    return false;
}

// @gml update try-catch
return regex("[-+]?[0-9]*\.?[0-9]+", str);