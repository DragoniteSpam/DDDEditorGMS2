/// @description smf_quat_multiply(Q, S)
/// @param Q[4]
/// @param S[4]
gml_pragma("forceinline");

var R, S;
R = argument0;
S = argument1;
return [R[3] * S[0] + R[0] * S[3] + R[1] * S[2] - R[2] * S[1], 
        R[3] * S[1] + R[1] * S[3] + R[2] * S[0] - R[0] * S[2], 
        R[3] * S[2] + R[2] * S[3] + R[0] * S[1] - R[1] * S[0], 
        R[3] * S[3] - R[0] * S[0] - R[1] * S[1] - R[2] * S[2]]