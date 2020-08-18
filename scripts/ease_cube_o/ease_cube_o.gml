/// @param v0
/// @param v1
/// @param f
function ease_cube_o(argument0, argument1, argument2) {

	// ease cubic out

	// weird arguments but they match the format used by http://www.gizma.com/easing
	var t = argument2 - 1;
	var b = argument0;
	var c = argument1 - argument0;

	return c * (t * t * t + 1) + b;


}
