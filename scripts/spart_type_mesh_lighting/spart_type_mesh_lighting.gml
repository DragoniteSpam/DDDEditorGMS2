/// @description spart_type_mesh_lighting(partType, ambientCol, lightCol, ldirX, ldirY, ldirZ)
/// @param partType
/// @param ambientCol
/// @param lightCol
/// @param ldirX
/// @param ldirY
/// @param ldirZ
/*
	Enables simple directional lighting for mesh particles.
	More advanced lighting will require manual tinkering with the shaders.

	Script created by TheSnidr
	www.thesnidr.com
*/
var partType = argument0;
var ambientCol = argument1;
var lightCol = argument2;
var ldirX = argument3;
var ldirY = argument4;
var ldirZ = argument5;
var l = point_distance_3d(0, 0, 0, ldirX, ldirY, ldirZ);
if (l == 0)
{
	l = 1;
	ldirZ = 1;
}
partType[| sPartTyp.MeshAmbientCol] = [color_get_red(ambientCol) / 255, color_get_green(ambientCol) / 255, color_get_blue(ambientCol) / 255];
partType[| sPartTyp.MeshLightCol] = [color_get_red(lightCol) / 255, color_get_green(lightCol) / 255, color_get_blue(lightCol) / 255];
partType[| sPartTyp.MeshLightDir] = [ldirX / l, ldirY / l, ldirZ / l];