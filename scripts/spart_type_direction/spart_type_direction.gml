/// @description spart_type_direction(partType, xdir, ydir, zdir, dir_vary, radial)
/// @param partType
/// @param xdir
/// @param ydir
/// @param zdir
/// @param dir_vary
/// @param radial
/*
	Set the starting direction vector of the particles, as well as an angle (in degrees)
	that defines how far the particles may deviate from the starting direction.
	Setting radial to true modifies the starting direction to point away from the center of the emitter.
		Particles that have been emitted by other particles will ignore its own direction, 
		and instead keep moving in the direction of its creator, plus the direction variation

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
var xdir = argument1;
var ydir = argument2;
var zdir = argument3;
var dirVary = degtorad(argument4);
var dirRadial = argument5;
var len = point_distance_3d(0, 0, 0, xdir, ydir, zdir);
if len > 0
{
	partType[| sPartTyp.Dir] = [xdir / len, ydir / len, zdir / len, dirVary];
}
else
{
	partType[| sPartTyp.Dir] = [0, 0, 1, dirVary];
}
partType[| sPartTyp.DirRadial] = dirRadial;