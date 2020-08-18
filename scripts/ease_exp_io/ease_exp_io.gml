/// @param v0
/// @param v1
/// @param f
function ease_exp_io(argument0, argument1, argument2) {

	// ease exponential in and out

	// weird arguments but they match the format used by http://www.gizma.com/easing
	var t = argument2 * 2;
	var b = argument0;
	var c = argument1 - argument0;

	if (t < 1) return c / 2 * power(2, 10 * (t - 1)) + b;
	t--;
	return c / 2 * (-power(2, -10 * t) + 2) + b;


}
