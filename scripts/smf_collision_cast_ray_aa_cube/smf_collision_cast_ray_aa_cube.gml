/// @description smf_collision_cast_ray_aa_cube(cubeX, cubeY, cubeZ, cubeSideLength, x1, y1, z1, x2, y2, z2)
/// @param cubeX
/// @param cubeY
/// @param cubeZ
/// @param cubeSideLength
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a given axis-aligned cube

Returns the intersection as an array of the following format:
[x, y, z, nx, ny, nz, intersection (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var cubePos, cubeHalfSize, dStart, dEnd, N, intersection, side, t, i, j, k, its;
cubePos = [argument0, argument1, argument2];
cubeHalfSize = argument3 / 2;
dStart = [argument4 - cubePos[0], argument5 - cubePos[1], argument6 - cubePos[2]];
dEnd =     [argument7 - cubePos[0], argument8 - cubePos[1], argument9 - cubePos[2]];

//Loop through the dimensions, checking for intersections with the nearest three sides of the block
N = [0, 0, 0];
intersection = false
for (i = 0; i < 3; i ++)
{
    if (dEnd[i] == dStart[i]){continue;}
    side = sign(dStart[i]);
    t = (side * cubeHalfSize - dStart[i]) / (dEnd[i] - dStart[i]);
    if ((t <= 0) or (t >= 1)){continue;}
    j = (i + 1) mod 3; 
    k = (i + 2) mod 3;
    its[j] = lerp(dStart[j], dEnd[j], t);
    its[k] = lerp(dStart[k], dEnd[k], t);
    if ((its[j] < -cubeHalfSize) or (its[j] > cubeHalfSize) or (its[k] < -cubeHalfSize) or (its[k] > cubeHalfSize)){continue;}
    dEnd[i] = side * cubeHalfSize;
    dEnd[j] = its[j];
    dEnd[k] = its[k];
    intersection = true;
    N = [0, 0, 0];
    N[i] = side;
}

return [cubePos[0] + dEnd[0], cubePos[1] + dEnd[1], cubePos[2] + dEnd[2], N[0], N[1], N[2], intersection];