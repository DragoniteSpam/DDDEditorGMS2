/// @description smf_rotate(vector, axis, angle)
/// @param vector[3]
/// @param axis[3]
/// @param angle
function smf_vector_rotate(argument0, argument1, argument2) {
    /*
    Rotates the point (x,y,z) around the vector [a,b,c] using Rodrigues' Rotation Formula
    */
    var c, s, d, v, a;
    v = argument0;
    a = argument1;
    c = cos(argument2);
    s = sin(argument2);
    d = (1 - c) * (a[0] * v[0] + a[1] * v[1] + a[2] * v[2]);
    return [v[0] * c + a[0] * d + (a[1] * v[2] - a[2] * v[1]) * s,
            v[1] * c + a[1] * d + (a[2] * v[0] - a[0] * v[2]) * s,
            v[2] * c + a[2] * d + (a[0] * v[1] - a[1] * v[0]) * s]


}
