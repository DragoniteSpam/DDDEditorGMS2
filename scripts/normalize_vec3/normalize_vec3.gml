/// @param vec3
// @todo gml update this will be part of the vec3 object

var v = argument0;
var l = point_distance_3d(0, 0, 0, v[0], v[1], v[2]);

if (l != 0) {
    return [v[0] / l, v[1] / l, v[2] / l];
}

return [0, 0, 1];