/// @description  boolean validate_double(string);
/// @param string

return regex("((\\+)|(\\-))?((\\d)*)((\\.)(\\d)+)?", argument0);

// ((\+)|(\-))?
//      optional + or -
// ((\d)*)
//      0 or more digits
// ((\.)(\d)+)?
//      optional decimal point followed by 1 or more digits
