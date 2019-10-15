/// @description smf_2d_to_3d_vector(camMat, fov, aspect, posX, posY)
/// @param camMat
/// @param fov
/// @param aspect
/// @param posX(0-1)
/// @param posY(0-1)
var ret, l, j,
camMat = argument0,
t = tan(argument1 * pi / 360),
_x = -(1 - 2 * argument3) * t * argument2,
_y = (1 - 2 * argument4) * t;
ret = [ camMat[0] + camMat[4] * _x + camMat[8] * _y,
        camMat[1] + camMat[5] * _x + camMat[9] * _y,
        camMat[2] + camMat[6] * _x + camMat[10] * _y];
l = sqrt(sqr(ret[0]) + sqr(ret[1]) + sqr(ret[2]));
if l == 0 return [1, 0, 0];
j = 1 / l;
return [ret[0] * j, ret[1] * j, ret[2] * j];