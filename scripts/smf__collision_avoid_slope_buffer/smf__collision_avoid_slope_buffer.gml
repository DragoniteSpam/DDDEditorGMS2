/// @description smf_collision_avoid_slope_buffer(modelIndex, x, y, z, radius, xup, yup, zup, slopeMin, slopeMax)
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param xup
/// @param yup
/// @param zup
/// @param slopeMin
/// @param slopeMax
/*
Makes the sphere (x, y, z) with the given radius avoid the given model.
Returns true if there is a collision and false if there isn't.
This script includes calculations to avoid sliding down shallow slopes
[returnX, returnY, returnZ] are the modified coordinates after avoiding the model
[returnXup, returnYup, returnZup] is the up-vector the most similar to the given up-vector

Script made by TheSnidr
www.TheSnidr.com
*/
var i, j, k, newPos, d, tris, addRadius, success, modelIndex, slopeMin, slopeMax, amount, tempDistance, tempUp, returnUp, t, v, uu, dp, tempPos, minDp, maxDp, minDist, nearest, nearestUp, nearestDist, V;

//Read collision buffer header
modelIndex = argument0;
var colBuff = modelIndex[| SMF_model.CollisionBuffer];
var octBuff = modelIndex[| SMF_model.OctreeBuffer];

addRadius = argument4;
returnUp = [argument5, argument6, argument7];

slopeMin = argument8;
slopeMax = argument9;
success = false;
minDp = 2;
maxDp = -2;

nearest = [0, 0, 0];
nearestUp = [0, 0, 1];
nearestDist = 99999;

var triCollisionPriority = ds_priority_create();

//Transform player coordinates
var modelPos;
buffer_seek(octBuff, buffer_seek_start, 4);
modelPos[0] = buffer_read(octBuff, buffer_f32);
modelPos[1] = buffer_read(octBuff, buffer_f32);
modelPos[2] = buffer_read(octBuff, buffer_f32);
newPos[0] = argument1 - modelPos[0]; 
newPos[1] = argument2 - modelPos[1]; 
newPos[2] = argument3 - modelPos[2]; 

tris = smf__collision_get_region_buffer(octBuff, newPos[0], newPos[1], newPos[2]);
var n = array_length_1d(tris);
for (i = 0; i < n; i ++){
    V = smf__collision_get_triangle_buffer(colBuff, tris[i]);
    //----------------------------------Check if the object is inside the triangle (we need to check each line in the triangle)
    for (j = 0; j < 9; j += 3){
        k = (j + 3) mod 9;
        t = [newPos[0] - V[j], newPos[1] - V[j+1], newPos[2] - V[j+2]];
        v = [V[k] - V[j], V[k+1] - V[j+1], V[k+2] - V[j+2]];
        if dot_product_3d(t[2] * v[1] - t[1] * v[2], t[0] * v[2] - t[2] * v[0], t[1] * v[0] - t[0] * v[1], V[9], V[10], V[11]) > 0 continue;
        //------------------------------If the object is not inside the triangle, the nearest point will be on one of the lines
        dp = median(dot_product_3d(v[0], v[1], v[2], t[0], t[1], t[2]) / (sqr(v[0]) + sqr(v[1]) + sqr(v[2])), 0, 1)
        tempPos = [V[j] + v[0] * dp, V[j+1] + v[1] * dp, V[j+2] + v[2] * dp];
        break;
    }
    //----------------------------------If the object is indeed inside the triangle, simply orthogonalize (project) the coordinates to the plane defined by the triangle
    if j == 9{
        var l = V[9] * t[0] + V[10] * t[1] + V[11] * t[2];
        tempPos = [newPos[0] - V[9] * l, newPos[1] - V[10] * l, newPos[2] - V[11] * l];
    }
    //----------------------------------Now, if the object is closer than it's supposed to, push it away from the model and return the new coordinates
    tempUp = smf_vector_normalize([newPos[0] - tempPos[0], newPos[1] - tempPos[1], newPos[2] - tempPos[2]]);
    if tempUp[3] <= addRadius and tempUp[3] > 0{
        d = [tempPos[0] + tempUp[0] * addRadius - newPos[0], tempPos[1] + tempUp[1] * addRadius - newPos[1], tempPos[2] + tempUp[2] * addRadius - newPos[2]];
        l = max(point_distance_3d(0, 0, 0, d[0], d[1], d[2]), 0.00001);
        dp = dot_product_3d(argument5, argument6, argument7, d[0], d[1], d[2]) / l;
        ds_priority_add(triCollisionPriority, i, dp);
    }
}

//Perform the test again on the triangles touching the player to make sure the triangles are avoided in the best order
var savedUpvector = false;
while ds_priority_size(triCollisionPriority){
    i = ds_priority_delete_max(triCollisionPriority);
    V = smf__collision_get_triangle_buffer(colBuff, tris[i]);
    for (var j = 0; j < 9; j += 3){
        k = (j + 3) mod 9;
        t = [newPos[0] - V[j], newPos[1] - V[j+1], newPos[2] - V[j+2]];
        v = [V[k] - V[j], V[k+1] - V[j+1], V[k+2] - V[j+2]];
        //------------------------------If the object is not inside the triangle, the nearest point will be on one of the lines
        if dot_product_3d(t[2] * v[1] - t[1] * v[2], t[0] * v[2] - t[2] * v[0], t[1] * v[0] - t[0] * v[1], V[9], V[10], V[11]) < 0{
            dp = median(dot_product_3d(v[0], v[1], v[2], t[0], t[1], t[2]) / (sqr(v[0]) + sqr(v[1]) + sqr(v[2])), 0, 1)
            tempPos = [V[j] + v[0] * dp, V[j+1] + v[1] * dp, V[j+2] + v[2] * dp];
            break;
        }
    }
    //----------------------------------If the object is indeed inside the triangle, simply orthogonalize (project) the coordinates to the plane defined by the triangle
    if j == 9{
        var l = V[9] * t[0] + V[10] * t[1] + V[11] * t[2];
        tempPos = [newPos[0] - V[9] * l, newPos[1] - V[10] * l, newPos[2] - V[11] * l];
    }
    tempUp = smf_vector_normalize([newPos[0] - tempPos[0], newPos[1] - tempPos[1], newPos[2] - tempPos[2]]);
    if tempUp[3] <= addRadius and tempUp[3] > 0{
        d = [tempPos[0] + tempUp[0] * addRadius - newPos[0], tempPos[1] + tempUp[1] * addRadius - newPos[1], tempPos[2] + tempUp[2] * addRadius - newPos[2]];
        l = max(point_distance_3d(0, 0, 0, d[0], d[1], d[2]), 0.00001);
        dp = dot_product_3d(argument5, argument6, argument7, d[0], d[1], d[2]) / l;
        //-------------------------------The triangle that has the most similar normal to the player's up-vector gets saved to the up-vector (and is not used in this script)
        if !savedUpvector{
            returnUp = [tempUp[0], tempUp[1], tempUp[2]];
            savedUpvector = true;
        }
        if dp > slopeMax{
            l = l / dp;
            d = [l * argument5, l * argument6, l * argument7];
        }
        else if dp > slopeMin{
            l = l / dp;
            amount = (dp - slopeMin) / (slopeMax - slopeMin);
            d = [lerp(d[0], l * argument5, amount), lerp(d[1], l * argument6, amount), lerp(d[2], l * argument7, amount)];
        }
        newPos = [newPos[0] + d[0], newPos[1] + d[1], newPos[2] + d[2]];
        success = true;
    }
}

ds_priority_destroy(triCollisionPriority);

//Transform player coordinates back into object space
return [modelPos[0] + newPos[0], modelPos[1] + newPos[1], modelPos[2] + newPos[2], returnUp[0], returnUp[1], returnUp[2], success];