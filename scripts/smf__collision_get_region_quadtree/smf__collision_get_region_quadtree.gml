/// @description smf__collision_get_region_quadtree_buffer(quadBuff, x, y)
/// @param quadBuff
/// @param x
/// @param y
/*
Returns an array containing the buffer positions of all triangles in this region

Script made by TheSnidr
www.TheSnidr.com
*/
gml_pragma("forceinline");
var quadBuff = argument0, r, s, n, ret = -1;
r = buffer_peek(quadBuff, 0, buffer_f32);
s = buffer_peek(quadBuff, 16, buffer_f32);
argument1 -= buffer_peek(quadBuff, 4, buffer_f32);
argument2 -= buffer_peek(quadBuff, 8, buffer_f32);
while r
{
    s /= 2;
    if (argument1 >= s){argument1 -= s; r += 4;}
    if (argument2 >= s){argument2 -= s; r += 8;}
    r = buffer_peek(quadBuff, r, buffer_f32);
}
buffer_seek(quadBuff, buffer_seek_start, -r);
n = buffer_read(quadBuff, buffer_f32);
for (var i = 0; i < n; i ++)
{
    ret[i] = buffer_read(quadBuff, buffer_f32);
}
return ret;