/// @description smf_collision_avoid_model_slope(modelIndex, x, y, z, radius, xup, yup, zup, slopeMin, slopeMax)
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
function smf_collision_sphere_avoid_model_slope(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9) {
	/*
	Makes the sphere (x, y, z) with the given radius avoid the given model.
	This script includes calculations to avoid sliding down shallow slopes
	Returns an array of the following format:
	[x, y, z, xup, yup, zup, collision (true or false)]

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var i, j, k, newPos, d, tris, addRadius, success, modelIndex, slopeMin, slopeMax, amount, tempDistance, tempUp, returnUp, t, u, v, uu, dp, tempPos, minDp, maxDp, minDist, nearest, nearestUp, nearestDist, V;

	//Read collision buffer header
	modelIndex = argument0;
	var colList = modelIndex[| SMF_model.CollisionList];
	var octList = modelIndex[| SMF_model.OctreeList];
	if colList == -1
	{
	    if modelIndex[| SMF_model.QuadtreeBuffer] >= 0{
	        return smf__collision_avoid_model_slope_quadtree(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9);}
	    return smf__collision_avoid_slope_buffer(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9);
	}

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
	newPos = [argument1 - octList[| 1], argument2 - octList[| 2], argument3 - octList[| 3]];

	tris = smf__collision_get_region(octList, newPos[0], newPos[1], newPos[2]);
	for (i = array_length(tris) - 1; i >= 0; i --)
	{
	    //----------------------------------Now, if the object is closer than it's supposed to, push it away from the model and return the new coordinates
	    tempPos = smf_project_to_triangle(newPos, colList[| tris[i]]);
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
	    tempPos = smf_project_to_triangle(newPos, colList[| tris[i]]);
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
	return [octList[| 1] + newPos[0], octList[| 2] + newPos[1], octList[| 3] + newPos[2], returnUp[0], returnUp[1], returnUp[2], success];


}
