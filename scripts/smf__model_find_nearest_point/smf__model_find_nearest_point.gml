/// @description smf_model_find_nearest_point(modelIndex, x, y, z)
/// @param modelIndex
/// @param x
/// @param y
/// @param z
function smf__model_find_nearest_point(argument0, argument1, argument2, argument3) {
	/*
	Makes the sphere (x, y, z) with the given radius avoid the given model

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var i, j, k, newX, newY, newZ, addRadius, success, tempDistance, tx, ty, tz, vx, vy, vz, dp, tempX, tempY, tempZ, minDp, maxDp, minDist, nearest, j, u, vert;
	var modelIndex = argument0;
	var colBuffer = modelIndex[| SMF_model.CollisionBuffer];
	minX = 0;
	minY = 0;
	minZ = 0;
	minDist = 99999;

	//Read collision buffer header
	buffer_seek(colBuffer, buffer_seek_start, 4);
	var modelX = buffer_read(colBuffer, buffer_f32);
	var modelY = buffer_read(colBuffer, buffer_f32);
	var modelZ = buffer_read(colBuffer, buffer_f32);
	var modelSize = buffer_read(colBuffer, buffer_f32);

	//Modify the player coordinates
	var transformScale = 65535 / modelSize
	newX = transformScale * (argument1 - modelX);
	newY = transformScale * (argument2 - modelY);
	newZ = transformScale * (argument3 - modelZ);

	var tris = smf__collision_get_nearest_region(colBuffer, newX, newY, newZ);
	for (i = 0; i < array_length(tris); i ++)
	{
	    vert = smf__collision_get_triangle(colBuffer, tris[i]);
	    //----------------------------------Check if the object is inside the triangle (we need to check each line in the triangle)
	    for (j = 0; j < 9; j += 3)
	    {
	        k = (j + 3) mod 9;
	        tx = newX - vert[j + 0];
	        ty = newY - vert[j + 1];
	        tz = newZ - vert[j + 2];
        
	        vx = vert[k + 0] - vert[j + 0];
	        vy = vert[k + 1] - vert[j + 1];
	        vz = vert[k + 2] - vert[j + 2];
	        //------------------------------If the object is not inside the triangle, the nearest point will be on one of the lines
	        if dot_product_3d(tz * vy - ty * vz, tx * vz - tz * vx, ty * vx - tx * vy, vert[9], vert[10], vert[11]) < 0
	        {
	            dp = median(dot_product_3d(vx, vy, vz, tx, ty, tz) / (sqr(vx) + sqr(vy) + sqr(vz)), 0, 1)
	            tempX = vert[j + 0] + vx * dp
	            tempY = vert[j + 1] + vy * dp
	            tempZ = vert[j + 2] + vz * dp
	            break;
	        }
	    }
	    //----------------------------------If the object is indeed inside the triangle, simply orthogonalize (project) the coordinates to the plane defined by the triangle
	    if j == 9
	    {
	        var l = vert[9] * tx + vert[10] * ty + vert[11] * tz;
	        tempX = newX - vert[9] * l;
	        tempY = newY - vert[10] * l;
	        tempZ = newZ - vert[11] * l;
	    }
	    var d = point_distance_3d(newX, newY, newZ, tempX, tempY, tempZ);
	    if d < minDist
	    {
	        minDist = d;
	        minX = tempX;
	        minY = tempY;
	        minZ = tempZ;
	    }
	}
	returnX = modelX + minX / transformScale;
	returnY = modelY + minY / transformScale;
	returnZ = modelZ + minZ / transformScale;
	return true;


}
