/// @description smf_quat_dot(Q, R)
/// @param Q[4]
/// @param R[4]
function smf_quat_dot(argument0, argument1) {
	gml_pragma("forceinline");

	var Q, R;
	Q = argument0;
	R = argument1;
	return Q[0] * R[0] + Q[1] * R[1] + Q[2] * R[2] + Q[3] * R[3];


}
