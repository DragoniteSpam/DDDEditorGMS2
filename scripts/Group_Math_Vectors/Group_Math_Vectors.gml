enum vec3 {
	xx, yy, zz
}

function vector3_normalize(vector) {
	gml_pragma("forceinline");
	var l = point_distance_3d(0, 0, 0, vector[0], vector[1], vector[2]);
	if (l != 0) {
	    return [vector[0] / l, vector[1] / l, vector[2] / l];
	}
	return [0, 0, 1];
}