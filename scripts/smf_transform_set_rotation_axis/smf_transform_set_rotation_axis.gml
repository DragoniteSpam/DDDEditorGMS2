/// @description d3d - Sets the transformation to a rotation around the axis indicated by the vector with the indicated amount.
/// @param xa the x component of the transform vector
/// @param ya the y component of the transform vector
/// @param za the z component of the transform vector
/// @param angle the angle to rotate the transform through the vector
function smf_transform_set_rotation_axis(argument0, argument1, argument2, argument3) {

	// get the sin and cos of the angle passed in
	var c = dcos(-argument3);
	var s = dsin(-argument3);
	var omc = 1 - c;

	// normalise the input vector
	var xx = argument0;
	var yy = argument1;
	var zz = argument2;
	var length2 = sqr(xx) + sqr(yy) + sqr(zz);
	var length = sqrt(length2);
	xx /= length;
	yy /= length;
	zz /= length;

	// build the rotation matrix
	var m = array_create(16);
	m[0] = omc * xx * xx + c;
	m[1] = omc * xx * yy + s * zz;
	m[2] = omc * xx * zz - s * yy;
	m[3] = 0;

	m[4] = omc * xx * yy - s * zz;
	m[5] = omc * yy * yy + c;
	m[6] = omc * yy * zz + s * xx;
	m[7] = 0;

	m[8] = omc * xx * zz + s * yy;
	m[9] = omc * yy * zz - s * xx;
	m[10] = omc * zz * zz + c;
	m[11] = 0;

	m[12] = 0;
	m[13] = 0;
	m[14] = 0;
	m[15] = 1;

	matrix_set( matrix_world, m);




}
