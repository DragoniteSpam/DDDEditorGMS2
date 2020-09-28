/// @description smf_collision_sphere_avoid_sphere(sphereX, sphereY, sphereZ, sphereRadius, x, y, z, radius, up[3])
/// @param sphereX
/// @param sphereY
/// @param sphereZ
/// @param sphereRadius
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param up[3]
function smf_collision_sphere_avoid_sphere(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8) {
    /*
    Makes the sphere (x, y, z) avoid the given sphere (sphereX, sphereY, sphereZ, sphereRadius)

    Returns an array of the following format:
    [x, y, z, xup, yup, zup, collision (true or false)]

    Script made by TheSnidr
    www.TheSnidr.com
    */
    var spherePos, sphereRadius, objectPos, objectRadius, retUp, combinedRadius, dPos, d, _d;
    spherePos = [argument0, argument1, argument2];
    sphereRadius = argument3;
    objectPos = [argument4, argument5, argument6];
    objectRadius = argument7;
    retUp = argument8;
    combinedRadius = sphereRadius + objectRadius;
    dPos = [objectPos[0] - spherePos[0], objectPos[1] - spherePos[1], objectPos[2] - spherePos[2]];

    //Compare the square of the distance to the square of the combined radii
    d = sqr(dPos[0]) + sqr(dPos[1]) + sqr(dPos[2]);
    if d >= sqr(combinedRadius) or d == 0{return [objectPos[0], objectPos[1], objectPos[2], retUp[0], retUp[1], retUp[2], false];}

    //The spheres intersect. Make the object sphere move out of the solid sphere
    _d = 1 / sqrt(d);
    retUp = [dPos[0] * _d, dPos[1] * _d, dPos[2] * _d];
    objectPos = [spherePos[0] + retUp[0] * combinedRadius, spherePos[1] + retUp[1] * combinedRadius, spherePos[2] + retUp[2] * combinedRadius]

    return [objectPos[0], objectPos[1], objectPos[2], retUp[0], retUp[1], retUp[2], true];


}
