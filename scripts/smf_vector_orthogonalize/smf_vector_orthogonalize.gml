/// @description smf_orthogonalize(normal[3], vector[3])
/// @param normal[3]
/// @param vector[3]
/*
Orthogonalizes a vector to a normal

Script made by TheSnidr

www.thesnidr.com
*/
gml_pragma("forceinline");
var n, v, l;
n = argument0;
v = argument1;
l = n[0] * v[0] + n[1] * v[1] + n[2] * v[2];
return [v[0] - n[0] * l,
		v[1] - n[1] * l,
		v[2] - n[2] * l];