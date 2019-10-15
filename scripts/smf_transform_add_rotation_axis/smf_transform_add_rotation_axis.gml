/// @description Sets the transformation to a rotation around the axis indicated by the vector with the indicated amount.
/// @param xa the x component of the transform vector
/// @param ya the y component of the transform vector
/// @param za the z component of the transform vector
/// @param angle the angle to rotate the transform through the vector

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
var mT = array_create(16);
mT[0] = omc * xx * xx + c;
mT[1] = omc * xx * yy + s * zz;
mT[2] = omc * xx * zz - s * yy;
mT[3] = 0;

mT[4] = omc * xx * yy - s * zz;
mT[5] = omc * yy * yy + c;
mT[6] = omc * yy * zz + s * xx;
mT[7] = 0;

mT[8] = omc * xx * zz + s * yy;
mT[9] = omc * yy * zz - s * xx;
mT[10] = omc * zz * zz + c;
mT[11] = 0;

mT[12] = 0;
mT[13] = 0;
mT[14] = 0;
mT[15] = 1;

var m = matrix_get( matrix_world );
var mR = matrix_multiply( m, mT );
matrix_set( matrix_world, mR );
