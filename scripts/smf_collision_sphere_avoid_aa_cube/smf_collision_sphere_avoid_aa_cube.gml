/// @description smf_collision_sphere_avoid_aa_cube(cubeX, cubeY, cubeZ, cubeSideLength, x, y, z, radius, up[3])
/// @param cubeX
/// @param cubeY
/// @param cubeZ
/// @param cubeSideLength
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param up[3]
/*
Makes the sphere (x, y, z) avoid the given axis-aligned cube.

Returns an array of the following format:
[x, y, z, xup, yup, zup, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var cubePos, cubeHalfSize, objectPos, objectRadius, retUp, combinedRadius, d, _d, dPos, dC, cC, C, i, j, k, Max;
cubePos = [argument0, argument1, argument2];
cubeHalfSize = argument3 / 2;
objectPos = [argument4, argument5, argument6];
objectRadius = argument7;
retUp = argument8;
dPos = [objectPos[0] - cubePos[0], objectPos[1] - cubePos[1], objectPos[2] - cubePos[2]];

//Convert from world coordinates to block normalized coordinates
Max = max(abs(dPos[0]), abs(dPos[1]), abs(dPos[2]));
C = [clamp(dPos[0], -cubeHalfSize, cubeHalfSize), clamp(dPos[1], -cubeHalfSize, cubeHalfSize), clamp(dPos[2], -cubeHalfSize, cubeHalfSize)];
if (Max <= cubeHalfSize)
{
	//The center of the sphere is inside the block. We need to move it out at any cost!
	for (i = 0; i < 3; i ++)
	{
		if abs(dPos[i]) != Max{continue;}
		C[i] = cubeHalfSize * sign(dPos[i]);
		retUp = [0, 0, 0];
		retUp[i] = sign(dPos[i]);
		break;
	}
}
else
{
	//The center of the sphere is outside the block. Make the sphere avoid the nearest point on the surface of the block.
	d = sqr(C[0] - dPos[0]) + sqr(C[1] - dPos[1]) + sqr(C[2] - dPos[2]);
	if d >= sqr(objectRadius){ //If the sphere is too far away, there is no intersection
		return [objectPos[0], objectPos[1], objectPos[2], retUp[0], retUp[1], retUp[2], false];}
	_d = 1 / sqrt(d); //<-- This is the only square root in this script
	retUp = [(dPos[0] - C[0]) * _d, (dPos[1] - C[1]) * _d, (dPos[2] - C[2]) * _d];
}

//The sphere intersects with the block. Make the object sphere move out of the solid block
objectPos = [cubePos[0] + C[0] + retUp[0] * objectRadius, cubePos[1] + C[1] + retUp[1] * objectRadius, cubePos[2] + C[2] + retUp[2] * objectRadius]
return [objectPos[0], objectPos[1], objectPos[2], retUp[0], retUp[1], retUp[2], true];