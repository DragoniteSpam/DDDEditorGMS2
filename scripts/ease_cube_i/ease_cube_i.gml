/// @param v0
/// @param v1
/// @param f
function ease_cube_i(argument0, argument1, argument2) {

	// ease cubic in

	// weird arguments but they match the format used by http://www.gizma.com/easing
	var t = argument2;
	var b = argument0;
	var c = argument1 - argument0;

	return c * t * t * t + b;


}
