/// @description smf_collision_sphere_avoid_block(blockMatrix, x, y, z, radius, up[3])
/// @param blockMatrix[16]
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param up[3]
/*
Makes the sphere (x, y, z) avoid the given block.
The block matrix can be created with matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale), where:
    (x, y, z) are the center coordinates of the cube,
    (xrot, yrot, zrot) are the euler angles of the cube, and
    (xscale, yscale, zscale) are half the side lengths of the cube (so the cube is actually twice as large as these values)

Returns an array of the following format:
[x, y, z, xup, yup, zup, collision (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var bM, objectPos, objectRadius, retUp, combinedRadius, d, _d, dPos, dC, cC, C, i, j, k, Max;
bM = argument0;
objectPos = [argument1, argument2, argument3];
objectRadius = argument4;
retUp = argument5;
dPos = [objectPos[0] - bM[12], objectPos[1] - bM[13], objectPos[2] - bM[14]];

//Convert from world coordinates to block normalized coordinates
dC=[dot_product_3d(dPos[0], dPos[1], dPos[2], bM[0], bM[1], bM[2])  / (sqr(bM[0]) + sqr(bM[1]) + sqr(bM[2])), 
    dot_product_3d(dPos[0], dPos[1], dPos[2], bM[4], bM[5], bM[6])  / (sqr(bM[4]) + sqr(bM[5]) + sqr(bM[6])), 
    dot_product_3d(dPos[0], dPos[1], dPos[2], bM[8], bM[9], bM[10]) / (sqr(bM[8]) + sqr(bM[9]) + sqr(bM[10]))];
Max = max(abs(dC[0]), abs(dC[1]), abs(dC[2]));
cC = [clamp(dC[0], -1, 1), clamp(dC[1], -1, 1), clamp(dC[2], -1, 1)];
if (Max <= 1)
{
    //The center of the sphere is inside the block. We need to move it out at any cost!
    for (i = 0; i < 3; i ++)
    {
        if abs(dC[i]) != Max{continue;}
        cC[i] = sign(dC[i]);
        C =[dot_product_3d(cC[0], cC[1], cC[2], bM[0], bM[4], bM[8]),
            dot_product_3d(cC[0], cC[1], cC[2], bM[1], bM[5], bM[9]),
            dot_product_3d(cC[0], cC[1], cC[2], bM[2], bM[6], bM[10])];
        retUp = [0, 0, 0];
        retUp[i] = cC[i];
        break;
    }
}
else
{
    //The center of the sphere is outside the block. Make the sphere avoid the nearest point on the surface of the block.
    C =[dot_product_3d(cC[0], cC[1], cC[2], bM[0], bM[4], bM[8]),
        dot_product_3d(cC[0], cC[1], cC[2], bM[1], bM[5], bM[9]),
        dot_product_3d(cC[0], cC[1], cC[2], bM[2], bM[6], bM[10])];
    d = sqr(C[0] - dPos[0]) + sqr(C[1] - dPos[1]) + sqr(C[2] - dPos[2]);
    if d >= sqr(objectRadius){ //If the sphere is too far away, there is no intersection
        return [objectPos[0], objectPos[1], objectPos[2], retUp[0], retUp[1], retUp[2], false];}
    _d = 1 / sqrt(d); //<-- This is the only square root in this script
    retUp = [(dPos[0] - C[0]) * _d, (dPos[1] - C[1]) * _d, (dPos[2] - C[2]) * _d];
}

//The sphere intersects with the block. Make the object sphere move out of the solid block
objectPos = [bM[12] + C[0] + retUp[0] * objectRadius, bM[13] + C[1] + retUp[1] * objectRadius, bM[14] + C[2] + retUp[2] * objectRadius]
return [objectPos[0], objectPos[1], objectPos[2], retUp[0], retUp[1], retUp[2], true];