/// @description smf__model_collisionbuffer_recursive_split(region_tri_list, regionX, regionY, regionZ, regionSize, bleedOver, level)
/// @param regionTriList
/// @param regionX
/// @param regionY
/// @param regionZ
/// @param regionSize
/// @param bleedOver
/// @param level
var i, j, k, d, tri, triInd, triVerts, rx, ry, rz, xx, yy, zz, splitList, mindist, rS, r, pos, tempR, nR, vx, vy, vz, vr, maxX, maxY, maxZ, minX, minY, minZ, splitPos, tempLevel, is_split, bufferCurrentPos, bufferRegionPos, boxSize, ret;
var regionTriList = argument0;
var regionX = argument1;
var regionY = argument2;
var regionSize = argument3 / 2;
var bleedOver = argument4;
var level = argument5;
var triNum = ds_list_size(regionTriList);
var returnLevel = level;

//Exit condition, write a list of all triangles in this region to the buffer
if (level >= 10 or triNum < 30 or regionSize <= 2 * bleedOver)
{
    i = 0;
    buffer_write(SMF__quadBuff, buffer_f32, triNum);
    repeat triNum buffer_write(SMF__quadBuff, buffer_f32, regionTriList[| i++]);
    if triNum == 0
        //If there are no triangles in this region, write a placeholder for a pointer to the nearest region containing triangles
        buffer_write(SMF__quadBuff, buffer_f32, 0);
    return 0;
}

//Write placeholders for the pointers to the 8 next regions
bufferRegionPos = buffer_tell(SMF__quadBuff);
for (i = 0; i < 4; i ++)
{
    splitList[i] = ds_list_create();
    buffer_write(SMF__quadBuff, buffer_f32, 0);
}

//Loop through all triangles in this region and assign them to the regions they cross
for (tri = 0; tri < triNum; tri ++)
{
    triInd = regionTriList[| tri];
    triVerts = smf__collision_get_triangle_quadtree(SMF__colBuff, triInd);
    for (i = 0; i < 4; i++)
    {
        var px = regionX+regionSize*(i mod 2) + SMF__Min[0];
        var py = regionY+regionSize*(i div 2) + SMF__Min[1];
        if rectangle_in_rectangle(
            min(triVerts[0], triVerts[3], triVerts[6]), min(triVerts[1], triVerts[4], triVerts[7]),
            max(triVerts[0], triVerts[3], triVerts[6]), max(triVerts[1], triVerts[4], triVerts[7]),
            px-bleedOver, py-bleedOver, px+regionSize+bleedOver, py+regionSize+bleedOver,){
            ds_list_add(splitList[i], triInd);
        }
    }
}

//Split each of the 8 subdivisions in a recursive manner. Each recursion writes itself to the buffer
for (i = 0; i < 4; i ++)
{
    splitPos[i] = buffer_tell(SMF__quadBuff);
    //The returned value "ret" has a dual functionality:
        //If positive, the returned number is the depth of the recursion.
        //If zero, the child region is not split and this branch of recursion has ended.
    ret = smf__collision_recursive_split_quadtree(splitList[i], regionX + regionSize * (i mod 2), regionY + regionSize * (i div 2), regionSize, bleedOver, level + 1);
    is_split[i] = (ret > 0);
    returnLevel = max(returnLevel, ret + (level + 1) * (ret == 0));
    ds_list_destroy(splitList[i]);
}

//Write the positions in the buffer of each child region 
bufferCurrentPos = buffer_tell(SMF__quadBuff);
buffer_seek(SMF__quadBuff, buffer_seek_start, bufferRegionPos)
for (i = 0; i < 4; i ++)
{
    //If the region is split, the result is positive
    //If the region is not split, the result is negative
    buffer_write(SMF__quadBuff, buffer_f32, splitPos[i] * (2 * is_split[i] - 1));
}

//Returns the recursive depth of the octree
buffer_seek(SMF__quadBuff, buffer_seek_start, bufferCurrentPos)
return returnLevel;
