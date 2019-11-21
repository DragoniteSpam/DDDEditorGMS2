/// @description smf_collision_cast_ray_block(blockMatrix, x1, y1, z1, x2, y2, z2)
/// @param blockMatrix
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/*
Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a block with the given matrix
The block matrix can be created with matrix_build(x, y, z, xrot, yrot, zrot, xscale, yscale, zscale), where:
    (x, y, z) are the center coordinates of the cube,
    (xrot, yrot, zrot) are the euler angles of the cube, and
    (xscale, yscale, zscale) are half the side lengths of the cube (so the cube is actually twice as large as these values)

Returns the intersection as an array of the following format:
[x, y, z, nx, ny, nz, intersection (true or false)]

Script made by TheSnidr
www.TheSnidr.com
*/
var bM, dStart, dEnd, l, lStart, lEnd, side, i, j, k, d, t, its, wEnd, N, intersection;
bM = argument0;
dStart = [argument1 - bM[12], argument2 - bM[13], argument3 - bM[14]];
dEnd =     [argument4 - bM[12], argument5 - bM[13], argument6 - bM[14]];

//Convert from world coordinates to block normalized coordinates
l =[1 / (sqr(bM[0]) + sqr(bM[1]) + sqr(bM[2])),
    1 / (sqr(bM[4]) + sqr(bM[5]) + sqr(bM[6])),
    1 / (sqr(bM[8]) + sqr(bM[9]) + sqr(bM[10]))];
    
lStart=[    dot_product_3d(dStart[0],dStart[1], dStart[2],    bM[0], bM[1], bM[2])  * l[0], 
            dot_product_3d(dStart[0],dStart[1], dStart[2],    bM[4], bM[5], bM[6])  * l[1], 
            dot_product_3d(dStart[0],dStart[1], dStart[2],    bM[8], bM[9], bM[10]) * l[2]];
            
lEnd=[        dot_product_3d(dEnd[0],     dEnd[1],    dEnd[2],    bM[0], bM[1], bM[2])  * l[0], 
            dot_product_3d(dEnd[0],     dEnd[1],    dEnd[2],    bM[4], bM[5], bM[6])  * l[1], 
            dot_product_3d(dEnd[0],     dEnd[1],    dEnd[2],    bM[8], bM[9], bM[10]) * l[2]];

//Loop through the dimensions, checking for intersections with the nearest three sides of the block
side = -1;
for (i = 0; i < 3; i ++)
{
    if (lEnd[i] == lStart[i]){continue;}
    t = (sign(lStart[i]) - lStart[i]) / (lEnd[i] - lStart[i]);
    if ((t <= 0) or (t >= 1)){continue;}
    j = (i + 1) mod 3; 
    k = (i + 2) mod 3;
    its[j] = lerp(lStart[j], lEnd[j], t);
    its[k] = lerp(lStart[k], lEnd[k], t);
    if ((its[j] < -1) or (its[j] > 1) or (its[k] < -1) or (its[k] > 1)){continue;}
    lEnd[i] = sign(lStart[i]);
    lEnd[j] = its[j];
    lEnd[k] = its[k];
    side = i;
}

//Convert the end coordinate back to world coordinates
wEnd = [bM[12] + dot_product_3d(lEnd[0], lEnd[1], lEnd[2], bM[0], bM[1], bM[2]),
        bM[13] + dot_product_3d(lEnd[0], lEnd[1], lEnd[2], bM[4], bM[5], bM[6]),
        bM[14] + dot_product_3d(lEnd[0], lEnd[1], lEnd[2], bM[8], bM[9], bM[10])];

//Find the normal of the intersection
N = [0, 0, 1];
intersection = false
if side >= 0
{
    intersection = true;
    d = sqrt(l[side]);
    N = [bM[side * 4] * d, bM[side * 4 + 1] * d, bM[side * 4 + 2] * d];
}

return [wEnd[0], wEnd[1], wEnd[2], N[0], N[1], N[2], intersection];