/// @description smf_collision_get_triangle(mBuff, triangleIndex)
/// @param mBuff
/// @param triangleIndex
function smf__collision_get_triangle_quadtree(argument0, argument1) {
    /*
    Returns a triangle as an array with three vertices and one normal

    Script made by TheSnidr
    www.TheSnidr.com
    */
    var mBuff = argument0, vert;
    buffer_seek(mBuff, buffer_seek_start, argument1*3 * SMF_format_bytes);
    for (var i = 0; i < 3; i ++){
        vert[i] = buffer_read(mBuff, buffer_f32);}
    buffer_seek(mBuff, buffer_seek_start, (argument1*3+1) * SMF_format_bytes);
    for (/*     */; i < 6; i ++){
        vert[i] = buffer_read(mBuff, buffer_f32);}
    buffer_seek(mBuff, buffer_seek_start, (argument1*3+2) * SMF_format_bytes);
    for (/*     */; i < 9; i ++){
        vert[i] = buffer_read(mBuff, buffer_f32);}
    return vert;


}
