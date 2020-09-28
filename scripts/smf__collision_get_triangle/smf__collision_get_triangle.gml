/// @description smf_collision_get_triangle(collisionGrid, triangleIndex)
/// @param collisionGrid
/// @param triangleIndex
function smf__collision_get_triangle(argument0, argument1) {
    /*
    Returns a triangle as an array with three vertices and one normal

    Script made by TheSnidr
    www.TheSnidr.com
    */
    var i = 0, vert;
    var colGrid = argument0;
    for (var i = 0; i < 12; i ++)
    {
        vert[i] = colGrid[# argument1, i];
    }
    return vert;


}
