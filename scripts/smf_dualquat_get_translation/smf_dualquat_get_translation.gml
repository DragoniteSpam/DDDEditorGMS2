/// @description smf_dualquat_get_translation(Q)
/// @param Q[8]
//Returns the translation of a given dual quaternion
gml_pragma("forceinline");

var Q = argument0;
return [2 * (-Q[7] * Q[0] + Q[4] * Q[3] + Q[6] * Q[1] - Q[5] * Q[2]), 
		2 * (-Q[7] * Q[1] + Q[5] * Q[3] + Q[4] * Q[2] - Q[6] * Q[0]), 
		2 * (-Q[7] * Q[2] + Q[6] * Q[3] + Q[5] * Q[0] - Q[4] * Q[1])];