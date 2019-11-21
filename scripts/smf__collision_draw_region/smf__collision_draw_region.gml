/// @description smf__collision_draw_region(modelIndex, x, y, z)
/// @param modelIndex
/// @param x
/// @param y
/// @param z
/*
Draws all triangles in the currently active region

Script made by TheSnidr
www.TheSnidr.com
*/
var i, j, k, n, newPos, d, tris, addRadius, success, tempDistance, tempUp, t, v, uu, dp, returnUp, tempPos, minDp, maxDp, minDist, nearest, nearestUp, V, col;

//Read collision header
var modelIndex = argument0;
var colBuff = modelIndex[| SMF_model.CollisionBuffer];
var octBuff = modelIndex[| SMF_model.OctreeBuffer];

if octBuff >= 0
{
    smf__collision_draw_region_buffer(argument0, argument1, argument2, argument3);
    return true;
}
if modelIndex[| SMF_model.QuadtreeBuffer] >= 0
{
    smf__collision_draw_region_quadtree(argument0, argument1, argument2);
    return true;
}
    
//Transform player coordinates
var modelPos;
buffer_seek(octBuff, buffer_seek_start, 4);
modelPos[0] = buffer_read(octBuff, buffer_f32);
modelPos[1] = buffer_read(octBuff, buffer_f32);
modelPos[2] = buffer_read(octBuff, buffer_f32);
    
tris = smf__collision_get_region_buffer(octBuff, argument1 - modelPos[0], argument2 - modelPos[1], argument3 - modelPos[2]);
n = array_length_1d(tris);

var vBuff = vertex_create_buffer();
vertex_begin(vBuff, SMF_debugformat);
for (i = 0; i < n; i ++)
{
    V = smf__collision_get_triangle_buffer(colBuff, tris[i]);
    col = make_color_hsv(tris[i] * 10, 255, 255);
    vertex_position_3d(vBuff, modelPos[0] + V[0] + V[9]*0.5, modelPos[1] + V[1] + V[10]*0.5, modelPos[2] + V[2] + V[11]*0.5);
    vertex_color(vBuff, col, 1);
    vertex_position_3d(vBuff, modelPos[0] + V[3] + V[9]*0.5, modelPos[1] + V[4] + V[10]*0.5, modelPos[2] + V[5] + V[11]*0.5);
    vertex_color(vBuff, col, 1);
    vertex_position_3d(vBuff, modelPos[0] + V[6] + V[9]*0.5, modelPos[1] + V[7] + V[10]*0.5, modelPos[2] + V[8] + V[11]*0.5);
    vertex_color(vBuff, col, 1);
}
vertex_end(vBuff);

shader_set(sh_smf_debug);
vertex_submit(vBuff, pr_trianglelist, -1);
shader_reset();
vertex_delete_buffer(vBuff);