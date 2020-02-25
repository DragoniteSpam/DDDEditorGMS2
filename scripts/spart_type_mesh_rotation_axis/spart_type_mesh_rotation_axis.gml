/// @description spart_type_mesh_rotation_axis(partType, x, y, z, axisDeviation)
/// @param partType
/// @param x
/// @param y
/// @param z
/// @param axisDeviation
/*
	Enables mesh rotation about a given axis.
	The axis may deviate from the given axis by axisDeviation degrees.
	Setting axisDeviation to 0 will make all particles rotate about the same
	axis, while setting it to 360 will make their rotation axes totally random.

	The rotation angle speeds are set in spart_type_orientation

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
var ax = argument1;
var ay = argument2;
var az = argument3;
var angle = argument4;
var l = point_distance_3d(0, 0, 0, ax, ay, az);
if (l == 0)
{
	l = 1;
	az = 1;
}
partType[| sPartTyp.MeshRotAxis] = [ax / l, ay / l, az / l, degtorad(angle)];