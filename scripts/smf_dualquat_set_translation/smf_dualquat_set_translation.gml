/// @description smf_dualquat_set_translation(DQ, x, y, z)
/// @param DQ[8]
/// @param x
/// @param y
/// @param z
function smf_dualquat_set_translation(argument0, argument1, argument2, argument3) {
    gml_pragma("forceinline");

    var Q, T, TR, i;
    Q = argument0;

    T[0] = argument1;
    T[1] = argument2;
    T[2] = argument3;
    T[3] = 0;
    TR = smf_quat_multiply(T, Q);
    for (i = 0; i < 4; i ++){Q[i + 4] = TR[i] / 2;}
    return Q;


}
