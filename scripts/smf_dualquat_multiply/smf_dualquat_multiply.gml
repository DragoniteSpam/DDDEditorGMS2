/// @description smf_dualquat_multiply(R, S)
/// @param R[8]
/// @param S[8]
//Multiplies two dual quaternions
//R * S = (A * C, A * D + B * C)
gml_pragma("forceinline");

var R, S;
R = argument0;
S = argument1;
return [R[3] * S[0] + R[0] * S[3] + R[1] * S[2] - R[2] * S[1],
        R[3] * S[1] + R[1] * S[3] + R[2] * S[0] - R[0] * S[2],
        R[3] * S[2] + R[2] * S[3] + R[0] * S[1] - R[1] * S[0],
        R[3] * S[3] - R[0] * S[0] - R[1] * S[1] - R[2] * S[2],
        R[3] * S[4] + R[0] * S[7] + R[1] * S[6] - R[2] * S[5] + R[7] * S[0] + R[4] * S[3] + R[5] * S[2] - R[6] * S[1],
        R[3] * S[5] + R[1] * S[7] + R[2] * S[4] - R[0] * S[6] + R[7] * S[1] + R[5] * S[3] + R[6] * S[0] - R[4] * S[2],
        R[3] * S[6] + R[2] * S[7] + R[0] * S[5] - R[1] * S[4] + R[7] * S[2] + R[6] * S[3] + R[4] * S[1] - R[5] * S[0],
        R[3] * S[7] - R[0] * S[4] - R[1] * S[5] - R[2] * S[6] + R[7] * S[3] - R[4] * S[0] - R[5] * S[1] - R[6] * S[2]];