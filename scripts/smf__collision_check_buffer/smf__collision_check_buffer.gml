/// @description smf__collision_avoid_buffer(modelIndex, x, y, z, radius)
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/// @param radius
/*
Returns true if there is a collision

Script made by TheSnidr
www.TheSnidr.com
*/
var i, j, k, n, pos, d, tris, addRadius, tempDistance, t, v, dp, V, returnUp, testPos;

//Read collision header
var modelIndex = argument0;
var colBuff = modelIndex[| SMF_model.CollisionBuffer];
var octBuff = modelIndex[| SMF_model.OctreeBuffer];

addRadius = argument4;
	
//Transform player coordinates
var modelPos;
buffer_seek(octBuff, buffer_seek_start, 4);
modelPos[0] = buffer_read(octBuff, buffer_f32);
modelPos[1] = buffer_read(octBuff, buffer_f32);
modelPos[2] = buffer_read(octBuff, buffer_f32);
pos[0] = argument1 - modelPos[0];
pos[1] = argument2 - modelPos[1];
pos[2] = argument3 - modelPos[2];
	
tris = smf__collision_get_region_buffer(octBuff, pos[0], pos[1], pos[2]);
n = array_length_1d(tris);
for (i = 0; i < n; i ++)
{
	V = smf__collision_get_triangle_buffer(colBuff, tris[i]);
	//----------------------------------Check if the object is inside the triangle (we need to check each line in the triangle)
	for (j = 0; j < 9; j += 3){
	    k = (j + 3) mod 9;
	    t = [pos[0] - V[j], pos[1] - V[j+1], pos[2] - V[j+2]];
	    v = [V[k] - V[j], V[k+1] - V[j+1], V[k+2] - V[j+2]];
	    if dot_product_3d(t[2] * v[1] - t[1] * v[2], t[0] * v[2] - t[2] * v[0], t[1] * v[0] - t[0] * v[1], V[9], V[10], V[11]) > 0 continue;
	    //------------------------------If the object is not inside the triangle, the nearest point will be on one of the lines
	    dp = median(dot_product_3d(v[0], v[1], v[2], t[0], t[1], t[2]) / (sqr(v[0]) + sqr(v[1]) + sqr(v[2])), 0, 1)
	    testPos = [V[j] + v[0] * dp, V[j+1] + v[1] * dp, V[j+2] + v[2] * dp];
	    break;
	}
	//----------------------------------If the object is indeed inside the triangle, simply orthogonalize (project) the coordinates to the plane defined by the triangle
	if j == 9
	{
	    var l = V[9] * t[0] + V[10] * t[1] + V[11] * t[2];
	    testPos = [pos[0] - V[9] * l, pos[1] - V[10] * l, pos[2] - V[11] * l];
	}
	//----------------------------------Now, if the object is closer than it's supposed to, push it away from the model and return the new coordinates
	if abs(pos[0] - testPos[0]) > addRadius continue;
	if abs(pos[1] - testPos[1]) > addRadius continue;
	if abs(pos[2] - testPos[2]) > addRadius continue;
	return true;
}

return false;