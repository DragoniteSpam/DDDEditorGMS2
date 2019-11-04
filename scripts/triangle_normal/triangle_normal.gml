/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3

gml_pragma("forceinline");

var v1x = argument3 - argument0;
var v1y = argument4 - argument1;
var v1z = argument5 - argument2;
var v2x = argument6 - argument0;
var v2y = argument7 - argument1;
var v2z = argument8 - argument2;

var cx = v1y * v2z - v1z * v2y;
var cy = -v1x * v2z + v1z * v2x;
var cz = v1x * v2y - v1y * v2x;

var cpl = point_distance_3d(0, 0, 0, cx, cy, cz);

if (cpl != 0) {
    return [cx / cpl, cy / cpl, cz / cpl];
}

return [0, 0, 1];