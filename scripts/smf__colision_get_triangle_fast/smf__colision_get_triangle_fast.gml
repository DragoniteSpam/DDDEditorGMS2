/// @description smf_collision_get_triangle_fast(collisionBuffer, triangleIndex)
/// @param collisionBuffer
/// @param triangleIndex
function smf__colision_get_triangle_fast(argument0, argument1) {
    /*
    Returns a triangle as an array with three vertices

    Script made by TheSnidr
    www.TheSnidr.com
    */
    var i = 0, vert;
    buffer_seek(argument0, buffer_seek_start, argument1 * SMF_colTriBytes)
    repeat 9{vert[i++] = buffer_read(argument0, buffer_f32);}
    return vert;


}
