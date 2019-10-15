/// @description smf_dualquat_get_conjugate(Q)
/// @param Q[8]
gml_pragma("forceinline");

var Q = argument0;
return [-Q[0], -Q[1], -Q[2], Q[3], -Q[4], -Q[5], -Q[6], Q[7]];