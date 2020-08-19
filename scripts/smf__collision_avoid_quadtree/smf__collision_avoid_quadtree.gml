/// @description smf__collision_avoid_quadtree(modelIndex, x, y, z, radius, xup, yup, zupx)
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/// @param radius
/// @param xup
/// @param yup
/// @param zup
function smf__collision_avoid_quadtree(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
	/*
	Makes the sphere (x, y, z) with the given radius avoid the given model.

	Returns an array of the following format:
	[x, y, z, xup, yup, zup, collision (true or false)]

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var retUp = [0, 0, 1], success = false, maxDp = -1;
	var i, j, k, n, newPos, d, tris, addRadius, success, tempDistance, tempUp, t, v, uu, dp, returnUp, tempPos, minDp, maxDp, minDist, nearest, nearestUp, V, N;

	//Read collision header
	var modelIndex = argument0;
	var mBuff = modelIndex[| SMF_model.MBuff];
	var quadBuff = modelIndex[| SMF_model.QuadtreeBuffer];
	var modelBuffer = mBuff[0];

	addRadius = argument4;
	newPos = [argument1, argument2, argument3];
	returnUp = [argument5, argument6, argument7];

	tris = smf__collision_get_region_quadtree(quadBuff, newPos[0], newPos[1]);
	n = array_length(tris);
	for (i = 0; i < n; i ++)
	{
	    V = smf__collision_get_triangle_quadtree(modelBuffer, tris[i]);
	    N = smf_vector_normalize(smf_vector_cross_product([V[3] - V[0], V[4] - V[1], V[5] - V[2]], [V[6] - V[0], V[7] - V[1], V[8] - V[2]]));
	    //----------------------------------Check if the object is inside the triangle (we need to check each line in the triangle)
	    for (j = 0; j < 9; j += 3){
	        k = (j + 3) mod 9;
	        t = [newPos[0] - V[j], newPos[1] - V[j+1], newPos[2] - V[j+2]];
	        v = [V[k] - V[j], V[k+1] - V[j+1], V[k+2] - V[j+2]];
	        if dot_product_3d(t[2] * v[1] - t[1] * v[2], t[0] * v[2] - t[2] * v[0], t[1] * v[0] - t[0] * v[1], N[0], N[1], N[2]) > 0 continue;
	        //------------------------------If the object is not inside the triangle, the nearest point will be on one of the lines
	        dp = median(dot_product_3d(v[0], v[1], v[2], t[0], t[1], t[2]) / (sqr(v[0]) + sqr(v[1]) + sqr(v[2])), 0, 1)
	        tempPos = [V[j] + v[0] * dp, V[j+1] + v[1] * dp, V[j+2] + v[2] * dp];
	        break;
	    }
	    //----------------------------------If the object is indeed inside the triangle, simply orthogonalize (project) the coordinates to the plane defined by the triangle
	    if j == 9{
	        var l = smf_vector_dot_product(N, t);
	        tempPos = [newPos[0] - N[0] * l, newPos[1] - N[1] * l, newPos[2] - N[2] * l];
	    }
	    //----------------------------------If the object is closer than it's supposed to, push it away from the model and return the new coordinates
	    tempPos = smf_project_to_triangle(newPos, V);
	    //----------------------------------Now, if the object is closer than it's supposed to, push it away from the model and return the new coordinates
	    tempUp = smf_vector_normalize([newPos[0] - tempPos[0], newPos[1] - tempPos[1], newPos[2] - tempPos[2]]);
	    if tempUp[3] <= addRadius and tempUp[3] > 0
	    {
	        success = true;
	        d = [tempPos[0] + tempUp[0] * addRadius - newPos[0], tempPos[1] + tempUp[1] * addRadius - newPos[1], tempPos[2] + tempUp[2] * addRadius - newPos[2]];
	        newPos = [newPos[0] + d[0], newPos[1] + d[1], newPos[2] + d[2]];
	        dp = dot_product_3d(argument5, argument6, argument7, d[0], d[1], d[2]) / max(point_distance_3d(0, 0, 0, d[0], d[1], d[2]), 0.00001);
	        //-------------------------------The triangle that has the most similar normal to the player's up-vector gets saved to the up-vector (and is not used in this script)
	        if dp >= maxDp
	        {
	            maxDp = dp
	            returnUp = [tempUp[0], tempUp[1], tempUp[2]];
	        }
	    }
	}

	//Transform player coordinates back into object space
	return [newPos[0], newPos[1], newPos[2], returnUp[0], returnUp[1], returnUp[2], success];


}
