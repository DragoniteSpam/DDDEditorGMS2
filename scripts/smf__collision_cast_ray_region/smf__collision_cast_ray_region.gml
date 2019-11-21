/// @description smf__collision_cast_ray_region(modelIndex, region, x1, y1, z1, x2, y2, z2)
/// @param modelIndex
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
var modelIndex = argument0;
var colList = modelIndex[| SMF_model.CollisionList];
var octList = modelIndex[| SMF_model.OctreeList];
var modelPos, lStart, lEnd, success, readPos, n, i, V, t, its, a, b, colGrid, octList, retN;
modelPos[0] = octList[| 1];
modelPos[1] = octList[| 2];
modelPos[2] = octList[| 3];
success = false;
lStart = [argument2 - modelPos[0], argument3 - modelPos[1], argument4 - modelPos[2]];
lEnd = [argument5 - modelPos[0], argument6 - modelPos[1], argument7 - modelPos[2]];
//If this is a leaf region, check for intersections with the triangles in this leaf
readPos = -argument1;
n = octList[| readPos];
for (i = 0; i < n; i ++)
{   //Find intersection with triangle plane
    V = octList[| 1 + i + readPos];
    t = dot_product_3d(colGrid[# V, 9], colGrid[# V, 10], colGrid[# V, 11], lEnd[0] - lStart[0], lEnd[1] - lStart[1], lEnd[2] - lStart[2]);
    if (t == 0) continue;
    t = dot_product_3d(colGrid[# V, 9], colGrid[# V, 10], colGrid[# V, 11], colGrid[# V, 0] - lStart[0], colGrid[# V, 1] - lStart[1], colGrid[# V, 2] - lStart[2]) / t;
    if (t <= 0 or t >= 1) continue;
    its = [lerp(lStart[0], lEnd[0], t), lerp(lStart[1], lEnd[1], t), lerp(lStart[2], lEnd[2], t)];
    //Check if the intersection is inside the triangle. If not, discard and continue.
    a = [its[0] - colGrid[# V, 0], its[1] - colGrid[# V, 1], its[2] - colGrid[# V, 2]];
    b = [colGrid[# V, 3] - colGrid[# V, 0], colGrid[# V, 4] - colGrid[# V, 1], colGrid[# V, 5] - colGrid[# V, 2]];
    if (dot_product_3d(colGrid[# V, 9], colGrid[# V, 10], colGrid[# V, 11], a[2] * b[1] - a[1] * b[2], a[0] * b[2] - a[2] * b[0], a[1] * b[0] - a[0] * b[1]) <= 0) continue;
    a = [its[0] - colGrid[# V, 3], its[1] - colGrid[# V, 4], its[2] - colGrid[# V, 5]];
    b = [colGrid[# V, 6] - colGrid[# V, 3], colGrid[# V, 7] - colGrid[# V, 4], colGrid[# V, 8] - colGrid[# V, 5]];
    if (dot_product_3d(colGrid[# V, 9], colGrid[# V, 10], colGrid[# V, 11], a[2] * b[1] - a[1] * b[2], a[0] * b[2] - a[2] * b[0], a[1] * b[0] - a[0] * b[1]) <= 0) continue;
    a = [its[0] - colGrid[# V, 6], its[1] - colGrid[# V, 7], its[2] - colGrid[# V, 8]];
    b = [colGrid[# V, 0] - colGrid[# V, 6], colGrid[# V, 1] - colGrid[# V, 7], colGrid[# V, 2] - colGrid[# V, 8]];
    if (dot_product_3d(colGrid[# V, 9], colGrid[# V, 10], colGrid[# V, 11], a[2] * b[1] - a[1] * b[2], a[0] * b[2] - a[2] * b[0], a[1] * b[0] - a[0] * b[1]) <= 0) continue;
    //The line intersects the triangle. Save the triangle normal and intersection.
    retN = [colGrid[# V, 9], colGrid[# V, 10], colGrid[# V, 11]];
    lEnd = [its[0], its[1], its[2]];
    success = true;
}