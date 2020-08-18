/// @param vec3a
/// @param vec3b
function vector3_add(argument0, argument1) {

	gml_pragma("forceinline");

	// @gml update this will be part of the vec3 object

	var v1 = argument0;
	var v2 = argument1;

	return [v1[@ vec3.xx] + v1[@ vec3.xx], v2[@ vec3.yy] + v2[@ vec3.yy], v1[@ vec3.zz] + v2[@ vec3.zz]];


}
