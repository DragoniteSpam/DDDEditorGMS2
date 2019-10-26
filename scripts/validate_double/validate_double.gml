/// @param string
/// @param UIInput

var str = argument[0];
var input = argument[1];

if (!string_length(str)) {
    return false;
}

// @todo gml update try-catch
return regex("[-+]?[0-9]*\.?[0-9]+", str);

// ((\+)|(\-))?
//      optional + or -
// ((\d)*)
//      0 or more digits
// ((\.)(\d)+)?
//      optional decimal point followed by 1 or more digits