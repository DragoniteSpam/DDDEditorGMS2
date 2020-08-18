/// @description smf_dualquat_create(angle, ax, ay, az, x, y, z)
/// @param angle
/// @param ax
/// @param ay
/// @param az
/// @param x
/// @param y
/// @param z
function smf_dualquat_create(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	//Creates a dual quaternion from axis angle and a translation vector
	//Source: http://en.wikipedia.org/wiki/Dual_quaternion
	gml_pragma("forceinline");

	var c, s;
	argument0 /= 2;
	c = cos(argument0);
	s = sin(argument0);
	argument1 *= s;
	argument2 *= s;
	argument3 *= s;

	return [argument1, argument2, argument3, c,
	        0.5 * (argument4 * c + argument5 * argument3 - argument6 * argument1),
	        0.5 * (argument5 * c + argument6 * argument1 - argument4 * argument3),
	        0.5 * (argument6 * c + argument4 * argument2 - argument5 * argument1),
	        0.5 * (- argument4 * argument1 - argument5 * argument2 - argument6 * argument3)];


}
