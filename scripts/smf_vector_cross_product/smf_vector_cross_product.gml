/// @description smf_vector_cross_product(u[3], v[3])
/// @param u[3]
/// @param v[3]
function smf_vector_cross_product(argument0, argument1) {
	gml_pragma("forceinline");
	var u, v;
	u = argument0;
	v = argument1;
	return [u[1] * v[2] - u[2] * v[1],
	        u[2] * v[0] - u[0] * v[2],
	        u[0] * v[1] - u[1] * v[0]];


}
