/// @description smf_matrix_create_from_dualquat(Q[8])
/// @param Q[8]
function smf_matrix_create_from_dualquat(argument0) {
	//Dual quaternion must be normalized
	//Source: http://en.wikipedia.org/wiki/Dual_quaternion
	gml_pragma("forceinline");
	var Q = argument0;
	return [
	sqr(Q[3]) + sqr(Q[0]) - sqr(Q[1]) - sqr(Q[2]), 
	2 * (Q[0] * Q[1] + Q[2] * Q[3]), 
	2 * (Q[0] * Q[2] - Q[1] * Q[3]), 0,
	2 * (Q[0] * Q[1] - Q[2] * Q[3]), 

	sqr(Q[3]) - sqr(Q[0]) + sqr(Q[1]) - sqr(Q[2]), 
	2 * (Q[1] * Q[2] + Q[0] * Q[3]), 0,
	2 * (Q[0] * Q[2] + Q[1] * Q[3]), 
	2 * (Q[1] * Q[2] - Q[0] * Q[3]), 

	sqr(Q[3]) - sqr(Q[0]) - sqr(Q[1]) + sqr(Q[2]), 0,
	2 * (-Q[7] * Q[0] + Q[4] * Q[3] + Q[6] * Q[1] - Q[5] * Q[2]), 
	2 * (-Q[7] * Q[1] + Q[5] * Q[3] + Q[4] * Q[2] - Q[6] * Q[0]), 
	2 * (-Q[7] * Q[2] + Q[6] * Q[3] + Q[5] * Q[0] - Q[4] * Q[1]), 
	1];


}
