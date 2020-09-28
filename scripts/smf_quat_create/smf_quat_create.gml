/// @description smf_quat_create(angle, ax, ay, az,)
/// @param angle
/// @param ax
/// @param ay
/// @param az
function smf_quat_create(argument0, argument1, argument2, argument3) {
    //Creates a quaternion from axis angle
    gml_pragma("forceinline");
    argument0 /= 2;
    var s = sin(argument0);
    return [argument1 * s, argument2 * s, argument3 * s, cos(argument0)];


}
