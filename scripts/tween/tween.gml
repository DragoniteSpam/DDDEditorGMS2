/// @param v0
/// @param v1
/// @param f
/// @param tween-type
function tween(argument0, argument1, argument2, argument3) {

	var v0 = argument0;
	var v1 = argument1;
	var f = argument2;
	var type = argument3;

	// big help: http://www.gizma.com/easing

	return script_execute(global.easing_equations[type], v0, v1, f);


}
