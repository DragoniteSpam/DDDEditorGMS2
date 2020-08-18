/// @description smf_collision_cast_ray_model(modelIndex, x1, y1, z1, x2, y2, z2)
/// @param modelIndex
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
function smf_collision_cast_ray_model(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	/*
	Casts a ray from one point to another and returns the position of the first collision with geometry
	Returns an array with the following format:
	[x, y, z, normalX, normalY, normalZ, success]

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var modelIndex = argument0, regionSize, progress = -1, stack = ds_stack_create(), regionPos, retN, v;
	var colList = modelIndex[| SMF_model.CollisionList];
	var octList = modelIndex[| SMF_model.OctreeList];
	if colList == -1
	{
	    return smf__collision_cast_ray_buffer(argument0, argument1, argument2, argument3, argument4, argument5, argument6);
	}

	var a, b, i, j, k, l, t, n, V, tris, modelPos, trScale, lStart, lEnd, readPos, halfSize, region, its, success;
	readPos = octList[| 0];
	modelPos[0] = octList[| 1];
	modelPos[1] = octList[| 2];
	modelPos[2] = octList[| 3];
	regionSize = octList[| 4];
	success = false;
	lStart = [argument1 - modelPos[0], argument2 - modelPos[1], argument3 - modelPos[2]];
	lEnd = [argument4 - modelPos[0], argument5 - modelPos[1], argument6 - modelPos[2]];
	its = array_create(3);
	regionPos = array_create(3);
	retN = array_create(3);
	region = array_create(3);
	repeat 1000 //Perform the iteration a maximum of 1000 times. This is an arbitrary limit.
	{
	    if (readPos > 0)
	    {   //Iterate through the octree
	        halfSize = regionSize / 2;
	        for (l = progress; l < 3; l ++)
	        {
	            if (l < 0)
	            {   //Check either the starting region of the ray or the first region it intersects
	                region = [(lStart[0] > regionPos[0] + halfSize), (lStart[1] > regionPos[1] + halfSize), (lStart[2] > regionPos[2] + halfSize)];
	                for (i = 0; i < 3; i ++)
	                {
	                    if (lEnd[i] == lStart[i]){continue;}
	                    if ((lStart[i] >= regionPos[i]) and (lStart[i] <= regionPos[i] + regionSize)){continue;}
	                    t = (regionPos[i] + region[i] * regionSize - lStart[i]) / (lEnd[i] - lStart[i]);
	                    if ((t <= 0) or (t >= 1)){continue;}
	                    j = (i + 1) mod 3; 
	                    k = (i + 2) mod 3;
	                    its[j] = lerp(lStart[j], lEnd[j], t) - regionPos[j];
	                    its[k] = lerp(lStart[k], lEnd[k], t) - regionPos[k];
	                    if ((its[j] < 0) or (its[j] > regionSize) or (its[k] < 0) or (its[k] > regionSize)){continue;}
	                    region[j] = (its[j] >= halfSize);
	                    region[k] = (its[k] >= halfSize);
	                    break;
	                }
	            }
	            else
	            {   //Check for intersections with the middle plane of each dimension
	                if (lEnd[l] == lStart[l]){continue;}
	                t = (regionPos[l] + halfSize - lStart[l]) / (lEnd[l] - lStart[l]);
	                if ((t <= 0) or (t >= 1)){continue;}
	                j = (l + 1) mod 3; 
	                k = (l + 2) mod 3;
	                its[j] = lerp(lStart[j], lEnd[j], t) - regionPos[j];
	                its[k] = lerp(lStart[k], lEnd[k], t) - regionPos[k];
	                if ((its[j] < 0) or (its[j] > regionSize) or (its[k] < 0) or (its[k] > regionSize)){continue;}
	                region[l] = (lStart[l] < regionPos[l] + halfSize);
	                region[j] = (its[j] >= halfSize);
	                region[k] = (its[k] >= halfSize);
	            }
	            //Push this region to stack and go to intersected child region
	            ds_stack_push(stack, readPos, regionPos[0], regionPos[1], regionPos[2], l);
	            if (region[0]){regionPos[0] += halfSize; readPos += 1;}
	            if (region[1]){regionPos[1] += halfSize; readPos += 2;}
	            if (region[2]){regionPos[2] += halfSize; readPos += 4;}
	            readPos = octList[| readPos];
	            regionSize /= 2;
	            progress = -1;
	            break;
	        }
	        if (l < 3){continue;} //If we ended the for-loop prematurely, we should also restart the while-loop
	    }
	    else
	    {   //If this is a leaf region, check for intersections with the triangles in this leaf
	        readPos = -readPos;
	        n = octList[| readPos];
	        for (i = 0; i < n; i ++)
	        {   //Find intersection with triangle plane
	            v = colList[| octList[| 1 + i + readPos]];
	            t = dot_product_3d(v[9], v[10], v[11], lEnd[0] - lStart[0], lEnd[1] - lStart[1], lEnd[2] - lStart[2]);
	            if (t == 0){continue;}
	            t = dot_product_3d(v[9], v[10], v[11], v[0] - lStart[0], v[1] - lStart[1], v[2] - lStart[2]) / t;
	            if ((t <= 0) or (t >= 1)){continue;}
	            its = [lerp(lStart[0], lEnd[0], t), lerp(lStart[1], lEnd[1], t), lerp(lStart[2], lEnd[2], t)];
	            //Check if the intersection is inside the triangle. If not, discard and continue.
	            a = [its[0] - v[0], its[1] - v[1], its[2] - v[2]];
	            b = [v[3] - v[0], v[4] - v[1], v[5] - v[2]];
	            if (dot_product_3d(v[9], v[10], v[11], a[2] * b[1] - a[1] * b[2], a[0] * b[2] - a[2] * b[0], a[1] * b[0] - a[0] * b[1]) <= 0){continue;}
	            a = [its[0] - v[3], its[1] - v[4], its[2] - v[5]];
	            b = [v[6] - v[3], v[7] - v[4], v[8] - v[5]];
	            if (dot_product_3d(v[9], v[10], v[11], a[2] * b[1] - a[1] * b[2], a[0] * b[2] - a[2] * b[0], a[1] * b[0] - a[0] * b[1]) <= 0){continue;}
	            a = [its[0] - v[6], its[1] - v[7], its[2] - v[8]];
	            b = [v[0] - v[6], v[1] - v[7], v[2] - v[8]];
	            if (dot_product_3d(v[9], v[10], v[11], a[2] * b[1] - a[1] * b[2], a[0] * b[2] - a[2] * b[0], a[1] * b[0] - a[0] * b[1]) <= 0){continue;}
	            //The line intersects the triangle. Save the triangle normal and intersection.
	            retN = [v[9], v[10], v[11]];
	            lEnd = [its[0], its[1], its[2]];
	            success = true;
	        }
	    }
	    if (ds_stack_size(stack) == 0){break;} //If the stack is empty, break the loop
	    //Pop the previous region from stack
	    progress = ds_stack_pop(stack) + 1;
	    regionPos = [ds_stack_pop(stack), ds_stack_pop(stack), ds_stack_pop(stack)];
	    readPos = ds_stack_pop(stack);
	    regionSize *= 2;
	}
	ds_stack_destroy(stack);
	return [modelPos[0] + lEnd[0], modelPos[1] + lEnd[1], modelPos[2] + lEnd[2], retN[0], retN[1], retN[2], success];


}
