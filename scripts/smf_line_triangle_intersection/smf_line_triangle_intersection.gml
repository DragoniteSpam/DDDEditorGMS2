/// @description smf_line_triangle_intersection(lineStart, lineEnd, triangle)
/// @param lineStart
/// @param lineEnd
/// @param triangle
function smf_line_triangle_intersection(argument0, argument1, argument2) {
    /*
    Script made by TheSnidr

    www.thesnidr.com
    */
    gml_pragma("forceinline");

    var lineStart, lineEnd, tri, dx, dy, dz, j, k, t, tx, ty, tz, vx, vy, vz, ret;
    lineStart = argument0;
    lineEnd = argument1;
    tri = argument2;

    dx = lineEnd[0] - lineStart[0];
    dy = lineEnd[1] - lineStart[1];
    dz = lineEnd[2] - lineStart[2];

    t = dot_product_3d(tri[9], tri[10], tri[11], dx, dy, dz);
    if t == 0 {return false;}
    t = dot_product_3d(tri[9], tri[10], tri[11], tri[0] - lineStart[0], tri[1] - lineStart[1], tri[2] - lineStart[2]) / t;
    if t <= 0 or t >= 1{return false;}
    ret[0] = lineStart[0] + dx * t;
    ret[1] = lineStart[1] + dy * t;
    ret[2] = lineStart[2] + dz * t;

    for (j = 0; j < 9; j += 3)
    {
        k = (j + 3) mod 9;
        tx = ret[0] - tri[j];
        ty = ret[1] - tri[j+1];
        tz = ret[2] - tri[j+2];
    
        vx = tri[k] - tri[j];
        vy = tri[k+1] - tri[j+1];
        vz = tri[k+2] - tri[j+2];
    
        if dot_product_3d(tz * vy - ty * vz, tx * vz - tz * vx, ty * vx - tx * vy, tri[9], tri[10], tri[11]) < 0
        {
            return false;
        }
    }
    return ret;


}
