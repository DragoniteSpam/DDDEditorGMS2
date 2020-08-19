/// @description smf_dualquat_lerp(R, S, amount)
/// @param R[8]
/// @param S[8]
/// @param amount
function smf_dualquat_lerp(argument0, argument1, argument2) {
    gml_pragma("forceinline");

    var R, S, Q, v1, v2, i;
    R = argument0;
    S = argument1;
    v2 = argument2;
    v1 = 1 - v2;
    for (i = 0; i < 8; i ++)
    {
        Q[i] = R[i] * v1 + S[i] * v2;
    }
    return Q;


}
