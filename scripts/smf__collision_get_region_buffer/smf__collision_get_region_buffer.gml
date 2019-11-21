/// @description smf_collision_get_region_buffer(octBuff, x, y, z)
/// @param octBuff
/// @param x
/// @param y
/// @param z
/*
Returns an array containing the buffer positions of all triangles in this region

Script made by TheSnidr
www.TheSnidr.com
*/
gml_pragma("forceinline");
var octBuff = argument0, r, s, n, ret = -1;
r = 4 * buffer_peek(octBuff, 0, buffer_f32);
s = buffer_peek(octBuff, 16, buffer_f32);
while r
{
    s /= 2;
    if (argument1 >= s){argument1 -= s; r += 4;}
    if (argument2 >= s){argument2 -= s; r += 8;}
    if (argument3 >= s){argument3 -= s; r += 16;}
    r = 4 * buffer_peek(octBuff, r, buffer_f32);
}
buffer_seek(octBuff, buffer_seek_start, -r);
n = buffer_read(octBuff, buffer_f32);
for (var i = 0; i < n; i ++)
{
    ret[i] = buffer_read(octBuff, buffer_f32);
}
return ret;