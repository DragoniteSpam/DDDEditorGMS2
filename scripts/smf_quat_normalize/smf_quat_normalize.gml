/// @description smf_quat_normalize(Q)
/// @param Q[4]
function smf_quat_normalize(argument0) {
    gml_pragma("forceinline");

    var Q, l;
    Q = argument0;
    l = sqrt(sqr(Q[0]) + sqr(Q[1]) + sqr(Q[2]) + sqr(Q[3]));
    if l > 0
    {
        l = 1 / l;
        return [Q[0] * l, Q[1] * l, Q[2] * l, Q[3] * l];
    }
    return [1, 0, 0, 0];


}
