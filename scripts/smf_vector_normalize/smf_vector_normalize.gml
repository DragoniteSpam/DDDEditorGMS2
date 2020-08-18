/// @description smf_normalize(v[3])
/// @param v[3]
function smf_vector_normalize(argument0) {
	//Returns the unit vector with the same direction
	//Also returns the length of the original vector
	gml_pragma("forceinline");
	var v, l, j;
	v = argument0;
	l = sqrt(sqr(v[0]) + sqr(v[1]) + sqr(v[2]));
	if l == 0{return [random_range(-1, 1), random_range(-1, 1), random_range(-1, 1), 0];}
	j = 1 / l;
	return [v[0] * j, v[1] * j, v[2] * j, l];


}
