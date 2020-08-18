/// @description smf_matrix_create_from_axisangle(axis[3], angle)
/// @param axis[3]
/// @param angle
function smf_matrix_create_from_axisangle(argument0, argument1) {
	//Creates a rotation matrix
	gml_pragma("forceinline");
	var u, v, w, a, c, s, d0, d1, d2;
	v = argument0;
	a = argument1;

	c = cos(a);
	s = sin(a);

	d0 = (1 - c) * v[0];
	d1 = (1 - c) * v[1];
	d2 = (1 - c) * v[2];
	return [c + v[0] * d0,        v[1] * d0 + v[2] * s,    v[2] * d0 - v[0] * s,    0,
	        u * d1 - v[2] * s,  c + v[1] * d1,            w * d1 + v[0] * s,        0,
	        u * d2 + v[1] * s,  v[1] * d2 - v[0] * s,    c + v[2] * d2,            0,
	        0,                    0,                        0,                        1];


}
