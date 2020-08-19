/// @description smf_collision_get_region(octList, x, y, z)
/// @param octList
/// @param x
/// @param y
/// @param z
function smf__collision_get_region(argument0, argument1, argument2, argument3) {
    /*
    Returns an array containing the buffer positions of all triangles in this region

    Script made by TheSnidr
    www.TheSnidr.com
    */
    gml_pragma("forceinline");
    var r, s, n, ret = -1;
    var octList = argument0;
    s = octList[| 4];
    r = octList[| 0];
    while r
    {
        s /= 2;
        if (argument1 >= s){argument1 -= s; r += 1;}
        if (argument2 >= s){argument2 -= s; r += 2;}
        if (argument3 >= s){argument3 -= s; r += 4;}
        r = octList[| r];
    }
    n = octList[| -r];
    for (var i = 0; i < n; i ++)
    {
        ret[i] = octList[| 1 + i - r];
    }
    return ret;


}
