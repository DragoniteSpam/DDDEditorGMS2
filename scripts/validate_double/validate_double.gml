/// @param string

if (!string_length(argument0)) {
    return false;
}

// @todo gml update try-catch
return regex("[-+]?[0-9]*\.?[0-9]+", argument0);

// ((\+)|(\-))?
//      optional + or -
// ((\d)*)
//      0 or more digits
// ((\.)(\d)+)?
//      optional decimal point followed by 1 or more digits