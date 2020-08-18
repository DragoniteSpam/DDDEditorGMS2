/// @param v0
/// @param v1
/// @param f
function ease_none(argument0, argument1, argument2) {

	// does not do any sort of easing; just returns the first value

	// weird arguments but they match the format used by http://www.gizma.com/easing
	var t = argument2;
	var b = argument0;
	var c = argument1 - argument0;

	return b;


}
