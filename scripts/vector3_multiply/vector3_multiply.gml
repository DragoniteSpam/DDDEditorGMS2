/// @param vec3
/// @param scalar

gml_pragma("forceinline");

// @gml update this will be part of the vec3 object

var v = argument0;
var s = argument1;

return [v[@ vec3.xx] * s, v[@ vec3.yy] * s, v[@ vec3.zz] * s];