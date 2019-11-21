/// @description smf__collision_draw_region(modelIndex, x, y)
/// @param modelIndex
/// @param x
/// @param y
/*
Draws all triangles in the currently active region

Script made by TheSnidr
www.TheSnidr.com
*/
var i, j, k, n, newPos, d, tris, addRadius, success, tempDistance, tempUp, t, v, uu, dp, returnUp, tempPos, minDp, maxDp, minDist, nearest, nearestUp, V, N, col;

//Read collision header
var modelIndex = argument0;
var mBuff = modelIndex[| SMF_model.MBuff];
var quadBuff = modelIndex[| SMF_model.QuadtreeBuffer];
    
//Transform player coordinates
var modelPos;
buffer_seek(quadBuff, buffer_seek_start, 4);
modelPos[0] = buffer_read(quadBuff, buffer_f32);
modelPos[1] = buffer_read(quadBuff, buffer_f32);
modelPos[2] = buffer_read(quadBuff, buffer_f32);
    
tris = smf__collision_get_region_quadtree(quadBuff, argument1 - modelPos[0], argument2 - modelPos[1]);
n = array_length_1d(tris);

var vBuff = vertex_create_buffer();
vertex_begin(vBuff, SMF_debugformat);
for (i = 0; i < n; i ++)
{
    V = smf__collision_get_triangle_quadtree(mBuff[0], tris[i]);
    N = smf_vector_normalize(smf_vector_cross_product([V[3] - V[0], V[4] - V[1], V[5] - V[2]], [V[6] - V[0], V[7] - V[1], V[8] - V[2]]));
    col = make_color_hsv(tris[i] * 10, 255, 255);
    vertex_position_3d(vBuff, modelPos[0] + V[0] + N[0]*0.5, modelPos[1] + V[1] + N[1]*0.5, modelPos[2] + V[2] + N[2]*0.5);
    vertex_color(vBuff, col, 1);
    vertex_position_3d(vBuff, modelPos[0] + V[3] + N[0]*0.5, modelPos[1] + V[4] + N[1]*0.5, modelPos[2] + V[5] + N[2]*0.5);
    vertex_color(vBuff, col, 1);
    vertex_position_3d(vBuff, modelPos[0] + V[6] + N[0]*0.5, modelPos[1] + V[7] + N[1]*0.5, modelPos[2] + V[8] + N[2]*0.5);
    vertex_color(vBuff, col, 1);
}
vertex_end(vBuff);

shader_set(sh_smf_debug);
vertex_submit(vBuff, pr_trianglelist, -1);
shader_reset();
vertex_delete_buffer(vBuff);